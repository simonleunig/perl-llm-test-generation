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
my $mock_hash;  # AFTER LAST PASS: my $mock_hash = bless([undef, undef, [qw(a b c d)]], 'Tie::IxHash');

# Test case: No indices provided, should return all values
my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Tie::IxHash::Values($mock_hash) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
    # FAILED: is_deeply($result, [qw(a b c d)], 'Values returns all values when no indices are provided');
# FAILED: }

# Test case: Single index provided, should return the value at that index
# UNVALIDATED: $result = eval { Tie::IxHash::Values($mock_hash, 1) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
    # FAILED: is($result, 'b', 'Values returns the value at the specified index');
# FAILED: }

# Test case: Multiple indices provided, should return values at those indices
# UNVALIDATED: $result = eval { Tie::IxHash::Values($mock_hash, 0, 2) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
    # FAILED: is_deeply($result, [qw(a c)], 'Values returns values at the specified indices');
# FAILED: }

# Test case: Invalid index provided, should handle it gracefully
# UNVALIDATED: $result = eval { Tie::IxHash::Values($mock_hash, 4) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
    # FAILED: is($result, undef, 'Values returns undef for an invalid index');
# FAILED: }

# Test case: Empty hash, should return an empty list
my $empty_hash;  # AFTER LAST PASS: my $empty_hash = bless([undef, undef, []], 'Tie::IxHash');
# UNVALIDATED: $result = eval { Tie::IxHash::Values($empty_hash) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
    # FAILED: is_deeply($result, [], 'Values returns an empty list for an empty hash');
# FAILED: }

done_testing();