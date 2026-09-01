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
    my $filename = 'test.xml';

    my $result = eval { XML::Simple::cache_write_memcopy($self, $data, $filename) };
    if ($@) { fail('Function crashed: ' . $@); } else { ok(1, 'Function did not crash'); }

    is($XML::Simple::MemCopyCache{$filename}, [{ cloned => { key => 'value' } }], 'Data is cached correctly');
}

# Test case 2: Invalid filename (edge case)
{
    my $self = {};
    my $data = { key => 'value' };
    my $filename = undef;

    my $result = eval { XML::Simple::cache_write_memcopy($self, $data, $filename) };
    if ($@) { fail('Function crashed: ' . $@); } else { ok(1, 'Function did not crash'); }

    is($XML::Simple::MemCopyCache{undef}, undef, 'Data is not cached for invalid filename');
}

# Test case 3: Storable module not available (edge case)
{
    # Unmock Storable to simulate it not being available
    unmock 'Storable';

    my $self = {};
    my $data = { key => 'value' };
    my $filename = 'test.xml';

    my $result = eval { XML::Simple::cache_write_memcopy($self, $data, $filename) };
    if ($@) { ok(1, 'Function crashed as expected'); } else { fail('Function did not crash'); }

    # Remock Storable for subsequent tests
    $mock = mock 'Storable' => ( override => [ dclone => sub {
        my ($data) = @_;
        return { cloned => $data };
    } ] );
}

# Test case 4: Empty data structure
{
    my $self = {};
    my $data = {};
    my $filename = 'test.xml';

    my $result = eval { XML::Simple::cache_write_memcopy($self, $data, $filename) };
    if ($@) { fail('Function crashed: ' . $@); } else { ok(1, 'Function did not crash'); }

    is($XML::Simple::MemCopyCache{$filename}, [{ cloned => {} }], 'Empty data is cached correctly');
}

done_testing();