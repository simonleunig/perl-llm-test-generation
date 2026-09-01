use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::Values"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'Values is defined'); }

# Mocking the Tie::IxHash object
my $mock_hash = bless([undef, undef, [1, 2, 3, 4, 5]], 'Tie::IxHash');

# Test case: No indices provided, should return all values
my $result = eval { Tie::IxHash::Values($mock_hash) };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, [1, 2, 3, 4, 5], 'Values returns all values when no indices are provided');
}

# Test case: Single index provided, should return the value at that index
$result = eval { Tie::IxHash::Values($mock_hash, 2) };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, [3], 'Values returns the value at the specified index');
}

# Test case: Multiple indices provided, should return values at those indices
$result = eval { Tie::IxHash::Values($mock_hash, 1, 3) };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, [2, 4], 'Values returns values at the specified indices');
}

# Test case: Invalid index provided, should handle it gracefully
$result = eval { Tie::IxHash::Values($mock_hash, 10) };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, [undef], 'Values returns undef for an invalid index');
}

# Test case: Empty hash, should return an empty list
my $empty_hash = bless([undef, undef, []], 'Tie::IxHash');
$result = eval { Tie::IxHash::Values($empty_hash) };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, [], 'Values returns an empty list for an empty hash');
}

done_testing();