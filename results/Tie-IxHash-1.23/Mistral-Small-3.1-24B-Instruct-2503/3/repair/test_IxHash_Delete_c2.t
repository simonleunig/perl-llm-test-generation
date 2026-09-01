use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::Delete"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'Delete is defined'); }

# Mocking the DELETE method of Tie::IxHash
my $mock;
eval { require Tie::IxHash; };
if ($@) {
    # DEPENDENCY MISSING: Tie::IxHash - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Tie::IxHash::DELETE"}) {
        $mock = mock 'Tie::IxHash' => (
            override => [
                DELETE => sub {
                    my ($self, $key) = @_;
                    delete $self->{$key};
                }
            ]
        );
    } else {
        $mock = mock 'Tie::IxHash' => (
            add => [
                DELETE => sub {
                    my ($self, $key) = @_;
                    delete $self->{$key};
                }
            ]
        );
    }
}

# Test case: No keys provided
{
    my $hash = bless { a => 1, b => 2, c => 3 }, 'Tie::IxHash';
    my $result = eval { Tie::IxHash::Delete($hash) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, undef, 'Delete returns undef when no keys are provided');
        is_deeply($hash, { a => 1, b => 2, c => 3 }, 'Hash remains unchanged');
    }
}

# Test case: Single key provided
{
    my $hash = bless { a => 1, b => 2, c => 3 }, 'Tie::IxHash';
    my $result = eval { Tie::IxHash::Delete($hash, 'b') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, undef, 'Delete returns undef when a single key is provided');
        is_deeply($hash, { a => 1, c => 3 }, 'Key "b" is deleted');
    }
}

# Test case: Multiple keys provided
{
    my $hash = bless { a => 1, b => 2, c => 3, d => 4 }, 'Tie::IxHash';
    my $result = eval { Tie::IxHash::Delete($hash, 'b', 'd') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, undef, 'Delete returns undef when multiple keys are provided');
        is_deeply($hash, { a => 1, c => 3 }, 'Keys "b" and "d" are deleted');
    }
}

# Test case: Non-existent keys provided
{
    my $hash = bless { a => 1, b => 2, c => 3 }, 'Tie::IxHash';
    my $result = eval { Tie::IxHash::Delete($hash, 'x', 'y') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, undef, 'Delete returns undef when non-existent keys are provided');
        is_deeply($hash, { a => 1, b => 2, c => 3 }, 'Hash remains unchanged');
    }
}

# Test case: Duplicate keys provided
{
    my $hash = bless { a => 1, b => 2, c => 3 }, 'Tie::IxHash';
    my $result = eval { Tie::IxHash::Delete($hash, 'b', 'b') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, undef, 'Delete returns undef when duplicate keys are provided');
        is_deeply($hash, { a => 1, c => 3 }, 'Key "b" is deleted only once');
    }
}

# Test case: Large list of keys
{
    my $hash = bless { map { $_ => 1 } 1..1000 }, 'Tie::IxHash';
    my $keys_to_delete = [1..500];
    my $result = eval { Tie::IxHash::Delete($hash, @$keys_to_delete) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, undef, 'Delete returns undef when a large list of keys is provided');
        is(scalar(keys %$hash), 500, '500 keys are deleted');
    }
}

done_testing();