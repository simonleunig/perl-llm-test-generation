use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::Clear"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'Clear is defined'); }

# Test case: Clear an empty hash
my $empty_hash = bless [ {}, [], [], 0 ], 'Tie::IxHash';
my $result = eval { Tie::IxHash::Clear($empty_hash) };
if ($@) { fail('Clear crashed on empty hash: ' . $@); } else {
    ok(defined $result, 'Clear returns result on empty hash');
    is($empty_hash->[0], {}, 'Hash key index is cleared');
    is_deeply($empty_hash->[1], [], 'Array of keys is cleared');
    is_deeply($empty_hash->[2], [], 'Array of data is cleared');
    is($empty_hash->[3], 0, 'Iter count is cleared');
}

# Test case: Clear a hash with a single element
my $single_element_hash = bless [ { key1 => 1 }, ['key1'], ['value1'], 1 ], 'Tie::IxHash';
$result = eval { Tie::IxHash::Clear($single_element_hash) };
if ($@) { fail('Clear crashed on single element hash: ' . $@); } else {
    ok(defined $result, 'Clear returns result on single element hash');
    is($single_element_hash->[0], {}, 'Hash key index is cleared');
    is_deeply($single_element_hash->[1], [], 'Array of keys is cleared');
    is_deeply($single_element_hash->[2], [], 'Array of data is cleared');
    is($single_element_hash->[3], 0, 'Iter count is cleared');
}

# Test case: Clear a hash with multiple elements
my $multiple_elements_hash = bless [ { key1 => 1, key2 => 2 }, ['key1', 'key2'], ['value1', 'value2'], 2 ], 'Tie::IxHash';
$result = eval { Tie::IxHash::Clear($multiple_elements_hash) };
if ($@) { fail('Clear crashed on multiple elements hash: ' . $@); } else {
    ok(defined $result, 'Clear returns result on multiple elements hash');
    is($multiple_elements_hash->[0], {}, 'Hash key index is cleared');
    is_deeply($multiple_elements_hash->[1], [], 'Array of keys is cleared');
    is_deeply($multiple_elements_hash->[2], [], 'Array of data is cleared');
    is($multiple_elements_hash->[3], 0, 'Iter count is cleared');
}

# Test case: Clear a hash with a large number of elements
my $large_elements_hash = bless [ { map { "key$_" => $_ } 1..1000 }, [ map { "key$_" } 1..1000 ], [ map { "value$_" } 1..1000 ], 1000 ], 'Tie::IxHash';
$result = eval { Tie::IxHash::Clear($large_elements_hash) };
if ($@) { fail('Clear crashed on large elements hash: ' . $@); } else {
    ok(defined $result, 'Clear returns result on large elements hash');
    is($large_elements_hash->[0], {}, 'Hash key index is cleared');
    is_deeply($large_elements_hash->[1], [], 'Array of keys is cleared');
    is_deeply($large_elements_hash->[2], [], 'Array of data is cleared');
    is($large_elements_hash->[3], 0, 'Iter count is cleared');
}

done_testing();