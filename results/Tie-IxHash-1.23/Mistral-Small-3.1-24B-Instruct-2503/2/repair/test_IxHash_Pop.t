use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::Pop"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'Pop is defined'); }

# Mock the Tie::IxHash object for testing
sub mock_tie_ixhash {
    my $self = bless [
        {},  # Index hash
        [],  # Keys array
        []   # Values array
    ], 'Tie::IxHash';
    return $self;
}

# Test case: Pop from an empty hash
{
    my $s = mock_tie_ixhash();
    my $result = eval { Tie::IxHash::Pop($s) };
    if ($@) { fail('Pop crashed: ' . $@); } else {
        is($result, undef, 'Pop returns undef when hash is empty');
    }
}

# Test case: Pop from a hash with one element
{
    my $s = mock_tie_ixhash();
    $s->[1] = ['key1'];
    $s->[2] = ['value1'];
    $s->[0]{'key1'} = 1;
    my $result = eval { Tie::IxHash::Pop($s) };
    if ($@) { fail('Pop crashed: ' . $@); } else {
        is_deeply($result, ['key1', 'value1'], 'Pop returns the correct key-value pair');
        is_deeply($s->[1], [], 'Keys array is empty after pop');
        is_deeply($s->[2], [], 'Values array is empty after pop');
        is($s->[0]{'key1'}, undef, 'Key is deleted from index hash');
    }
}

# Test case: Pop from a hash with multiple elements
{
    my $s = mock_tie_ixhash();
    $s->[1] = ['key1', 'key2', 'key3'];
    $s->[2] = ['value1', 'value2', 'value3'];
    $s->[0]{'key1'} = 1;
    $s->[0]{'key2'} = 2;
    $s->[0]{'key3'} = 3;
    my $result = eval { Tie::IxHash::Pop($s) };
    if ($@) { fail('Pop crashed: ' . $@); } else {
        is_deeply($result, ['key3', 'value3'], 'Pop returns the correct key-value pair');
        is_deeply($s->[1], ['key1', 'key2'], 'Keys array has correct remaining elements');
        is_deeply($s->[2], ['value1', 'value2'], 'Values array has correct remaining elements');
        is($s->[0]{'key3'}, undef, 'Key is deleted from index hash');
    }
}

# Test case: Pop from a hash with multiple elements, multiple pops
{
    my $s = mock_tie_ixhash();
    $s->[1] = ['key1', 'key2', 'key3'];
    $s->[2] = ['value1', 'value2', 'value3'];
    $s->[0]{'key1'} = 1;
    $s->[0]{'key2'} = 2;
    $s->[0]{'key3'} = 3;

    my $result1 = eval { Tie::IxHash::Pop($s) };
    if ($@) { fail('Pop crashed: ' . $@); } else {
        is_deeply($result1, ['key3', 'value3'], 'First Pop returns the correct key-value pair');
    }

    my $result2 = eval { Tie::IxHash::Pop($s) };
    if ($@) { fail('Pop crashed: ' . $@); } else {
        is_deeply($result2, ['key2', 'value2'], 'Second Pop returns the correct key-value pair');
    }

    my $result3 = eval { Tie::IxHash::Pop($s) };
    if ($@) { fail('Pop crashed: ' . $@); } else {
        is_deeply($result3, ['key1', 'value1'], 'Third Pop returns the correct key-value pair');
    }

    my $result4 = eval { Tie::IxHash::Pop($s) };
    if ($@) { fail('Pop crashed: ' . $@); } else {
        is($result4, undef, 'Fourth Pop returns undef when hash is empty');
    }
}

done_testing();