use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::Keys"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'Keys is defined'); }

# Mocking the Tie::IxHash object
my $mock_hash = bless([], 'Tie::IxHash');

# Test case 1: No indices provided, should return all keys
{
    my $result = eval {
        $mock_hash->[1] = ['key1', 'key2', 'key3'];
        Tie::IxHash::Keys($mock_hash);
    };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, ['key1', 'key2', 'key3'], 'Returns all keys when no indices are provided');
    }
}

# Test case 2: One index provided, should return the key at that index
{
    my $result = eval {
        $mock_hash->[1] = ['key1', 'key2', 'key3'];
        Tie::IxHash::Keys($mock_hash, 1);
    };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 'key2', 'Returns the key at the specified index');
    }
}

# Test case 3: Multiple indices provided, should return keys at those indices
{
    my $result = eval {
        $mock_hash->[1] = ['key1', 'key2', 'key3'];
        Tie::IxHash::Keys($mock_hash, 0, 2);
    };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, ['key1', 'key3'], 'Returns keys at the specified indices');
    }
}

# Test case 4: Invalid index provided, should handle gracefully
{
    my $result = eval {
        $mock_hash->[1] = ['key1', 'key2', 'key3'];
        Tie::IxHash::Keys($mock_hash, 5);
    };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, undef, 'Handles invalid index gracefully');
    }
}

# Test case 5: Empty hash, should return an empty list
{
    my $result = eval {
        $mock_hash->[1] = [];
        Tie::IxHash::Keys($mock_hash);
    };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, [], 'Returns an empty list for an empty hash');
    }
}

done_testing();