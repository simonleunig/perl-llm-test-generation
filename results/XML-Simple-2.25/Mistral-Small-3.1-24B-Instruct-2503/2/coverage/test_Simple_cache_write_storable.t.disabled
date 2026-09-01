use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw(mock unmock);
use File::Temp qw(tempfile tempdir);
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Mocking dependencies
my $mock;
eval { require Storable; };
if ($@) {
    # DEPENDENCY MISSING: Storable - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Storable::nstore"}) {
        $mock = mock 'Storable' => (
            override => [
                nstore => sub { return 1; },
                lock_nstore => sub { return 1; },
            ]
        );
    } else {
        $mock = mock 'Storable' => (
            add => [
                nstore => sub { return 1; },
                lock_nstore => sub { return 1; },
            ]
        );
    }
}

# Mocking the storable_filename method
mock 'XML::Simple' => (
    storable_filename => sub {
        my ($self, $filename) = @_;
        return File::Spec->catfile(tempdir(CLEANUP => 1), $filename . '.cache');
    },
);

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::cache_write_storable"} };
if ($@) {
    fail('Symbol check crashed: ' . $@);
} else {
    ok($symbol_check, 'cache_write_storable is defined');
}

# Test case: Normal operation on non-VMS system
{
    my $data = { key => 'value' };
    my $filename = 'test.xml';
    my $self = bless {}, 'XML::Simple';

    my $result = eval { XML::Simple::cache_write_storable($self, $data, $filename) };
    if ($@) {
        fail('Function crashed: ' . $@);
    } else {
        ok(defined $result, 'Function returns result');
        ok(-e File::Spec->catfile(tempdir(CLEANUP => 1), $filename . '.cache'), 'Cache file created');
    }
}

# Test case: Normal operation on VMS system
{
    local $^O = 'VMS';
    my $data = { key => 'value' };
    my $filename = 'test_vms.xml';
    my $self = bless {}, 'XML::Simple';

    my $result = eval { XML::Simple::cache_write_storable($self, $data, $filename) };
    if ($@) {
        fail('Function crashed: ' . $@);
    } else {
        ok(defined $result, 'Function returns result');
        ok(-e File::Spec->catfile(tempdir(CLEANUP => 1), $filename . '.cache'), 'Cache file created');
    }
}

# Test case: Error handling with missing Storable module
{
    unmock 'Storable';
    my $data = { key => 'value' };
    my $filename = 'test_missing_storable.xml';
    my $self = bless {}, 'XML::Simple';

    my $result = eval { XML::Simple::cache_write_storable($self, $data, $filename) };
    if ($@) {
        like($@, qr/Can't locate Storable.pm/, 'Error when Storable is not available');
    } else {
        fail('Function did not crash as expected');
    }
    mock 'Storable' => (
        nstore => sub { return 1; },
        lock_nstore => sub { return 1; },
    );
}

done_testing();