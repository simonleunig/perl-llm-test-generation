use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::new"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'new is defined'); }

# Test case: No key-value pairs provided
my $result = eval { Tie::IxHash->new() };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'Function returns result when no key-value pairs are provided');
    isa_ok($result, 'Tie::IxHash', 'Result is a Tie::IxHash object');
}

# Test case: Single key-value pair provided
$result = eval { Tie::IxHash->new(key => 'value') };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'Function returns result with a single key-value pair');
    isa_ok($result, 'Tie::IxHash', 'Result is a Tie::IxHash object');
    is($result->{key}, 'value', 'Key-value pair is correctly stored');
}

# Test case: Multiple key-value pairs provided
$result = eval { Tie::IxHash->new(key1 => 'value1', key2 => 'value2') };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'Function returns result with multiple key-value pairs');
    isa_ok($result, 'Tie::IxHash', 'Result is a Tie::IxHash object');
    is($result->{key1}, 'value1', 'First key-value pair is correctly stored');
    is($result->{key2}, 'value2', 'Second key-value pair is correctly stored');
}

# Test case: Duplicate keys provided
$result = eval { Tie::IxHash->new(key => 'value1', key => 'value2') };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'Function returns result with duplicate keys');
    isa_ok($result, 'Tie::IxHash', 'Result is a Tie::IxHash object');
    is($result->{key}, 'value2', 'Last value for duplicate key is correctly stored');
}

# Test case: Invalid input (non-key-value pairs)
$result = eval { Tie::IxHash->new('invalid') };
if ($@) {
    like($@, qr/^Odd number of elements in hash assignment/, 'Function raises error for invalid input');
} else {
    fail('Function did not crash with invalid input');
}

done_testing();