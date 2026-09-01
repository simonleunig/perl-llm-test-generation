use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw(mock unmock);
use File::Temp qw(tempfile tempdir);
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::cache_write_memcopy"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'cache_write_memcopy is defined'); }

# Mocking Storable::dclone
my $mock;
eval { require Storable; };
if ($@) {
    # DEPENDENCY MISSING: Storable - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Storable::dclone"}) {
        $mock = mock 'Storable' => ( override => [ dclone => sub {
            my ($data) = @_;
            return { cloned => $data };
        } ] );
    } else {
        $mock = mock 'Storable' => ( add => [ dclone => sub {
            my ($data) = @_;
            return { cloned => $data };
        } ] );
    }
}

# Test case 1: Normal operation
{
    my $self = {};
    my $data = { key => 'value' };
    my ($fh, $filename) = tempfile();
    close($fh);

    my $result = eval { XML::Simple::cache_write_memcopy($self, $data, $filename) };
    if ($@) { fail('Function crashed: ' . $@); } else { ok(1, 'Function did not crash'); }

    is($XML::Simple::MemCopyCache{$filename}, [{ cloned => { key => 'value' } }], 'Data correctly cached');
}

# Test case 2: Invalid data structure
{
    my $self = {};
    my $data = undef;
    my ($fh, $filename) = tempfile();
    close($fh);

    my $result = eval { XML::Simple::cache_write_memcopy($self, $data, $filename) };
    if ($@) { fail('Function crashed: ' . $@); } else { ok(1, 'Function did not crash'); }

    is($XML::Simple::MemCopyCache{$filename}, undef, 'Invalid data structure not cached');
}

# Test case 3: Missing Storable module
{
    # Unmock Storable to simulate missing module
    unmock 'Storable';

    my $self = {};
    my $data = { key => 'value' };
    my ($fh, $filename) = tempfile();
    close($fh);

    my $result = eval { XML::Simple::cache_write_memcopy($self, $data, $filename) };
    if ($@) { ok(1, 'Function crashed as expected'); } else { fail('Function did not crash'); }

    is($XML::Simple::MemCopyCache{$filename}, undef, 'Data not cached when Storable is missing');
}

# Clean up
unmock 'Storable';

done_testing();