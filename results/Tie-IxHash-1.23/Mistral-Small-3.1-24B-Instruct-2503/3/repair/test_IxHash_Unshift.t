use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::Unshift"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'Unshift is defined'); }

# Helper function to create a mock Tie::IxHash object
sub create_mock_ixhash {
    my $mock = mock('Tie::IxHash');
    $mock->mock('TIEHASH', sub { bless [ { }, [], [] ], 'Tie::IxHash' });
    return $mock;
}

# Test case: No key-value pairs provided
{
    my $mock = create_mock_ixhash();
    my $hash = $mock->instance;
    my $result = eval { Tie::IxHash::Unshift($hash) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 0, 'Unshift returns 0 when no key-value pairs are provided');
    }
}

# Test case: Adding new key-value pairs
{
    my $mock = create_mock_ixhash();
    my $hash = $mock->instance;
    my $result = eval { Tie::IxHash::Unshift($hash, 'key1', 'value1', 'key2', 'value2') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 2, 'Unshift returns 2 when adding 2 key-value pairs');
        is($hash->[1][0], 'key1', 'First key is "key1"');
        is($hash->[1][1], 'key2', 'Second key is "key2"');
        is($hash->[2][0], 'value1', 'First value is "value1"');
        is($hash->[2][1], 'value2', 'Second value is "value2"');
    }
}

# Test case: Updating existing key-value pairs
{
    my $mock = create_mock_ixhash();
    my $hash = $mock->instance;
    eval { Tie::IxHash::Unshift($hash, 'key1', 'value1') };
    my $result = eval { Tie::IxHash::Unshift($hash, 'key1', 'new_value1') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 1, 'Unshift returns 1 when updating an existing key-value pair');
        is($hash->[2][0], 'new_value1', 'First value is updated to "new_value1"');
    }
}

# Test case: Adding and updating key-value pairs
{
    my $mock = create_mock_ixhash();
    my $hash = $mock->instance;
    eval { Tie::IxHash::Unshift($hash, 'key1', 'value1') };
    my $result = eval { Tie::IxHash::Unshift($hash, 'key2', 'value2', 'key1', 'new_value1') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 2, 'Unshift returns 2 when adding and updating key-value pairs');
        is($hash->[1][0], 'key2', 'First key is "key2"');
        is($hash->[1][1], 'key1', 'Second key is "key1"');
        is($hash->[2][0], 'value2', 'First value is "value2"');
        is($hash->[2][1], 'new_value1', 'Second value is "new_value1"');
    }
}

# Test case: Adding multiple key-value pairs
{
    my $mock = create_mock_ixhash();
    my $hash = $mock->instance;
    my $result = eval { Tie::IxHash::Unshift($hash, 'key1', 'value1', 'key2', 'value2', 'key3', 'value3') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 3, 'Unshift returns 3 when adding 3 key-value pairs');
        is($hash->[1][0], 'key1', 'First key is "key1"');
        is($hash->[1][1], 'key2', 'Second key is "key2"');
        is($hash->[1][2], 'key3', 'Third key is "key3"');
        is($hash->[2][0], 'value1', 'First value is "value1"');
        is($hash->[2][1], 'value2', 'Second value is "value2"');
        is($hash->[2][2], 'value3', 'Third value is "value3"');
    }
}

done_testing();