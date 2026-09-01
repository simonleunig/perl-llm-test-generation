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

# Test case 1: Test with a single index
my $tie = tie my %hash, 'Tie::IxHash';
$hash{a} = 1;
$hash{b} = 2;
my $result = eval { Tie::IxHash::Keys($tie, 0) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'a', 'Single index returns correct key'); }

# Test case 2: Test with multiple indices
$result = eval { Tie::IxHash::Keys($tie, 0, 1) };
if ($@) { fail('Function crashed: ' . $@); } else { is_deeply($result, ['a', 'b'], 'Multiple indices return correct keys'); }

# Test case 3: Test with no indices
$result = eval { Tie::IxHash::Keys($tie) };
if ($@) { fail('Function crashed: ' . $@); } else { is_deeply($result, ['a', 'b'], 'No indices return all keys'); }

# Test case 4: Test with out-of-range index
$result = eval { Tie::IxHash::Keys($tie, 2) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, undef, 'Out-of-range index returns undef'); }

# Test case 5: Test with non-integer index
$result = eval { Tie::IxHash::Keys($tie, 'a') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, undef, 'Non-integer index returns undef'); }

done_testing();
