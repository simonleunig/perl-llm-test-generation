use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::NEXTKEY"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'NEXTKEY is defined'); }

# Test case 1: Normal operation with existing keys
my $tie = tie my %hash, 'Tie::IxHash';
$hash{a} = 1;
$hash{b} = 2;
$hash{c} = 3;
my $result = eval { Tie::IxHash::NEXTKEY($tie) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'a', 'NEXTKEY returns first key'); }

# Test case 2: Normal operation with next key
my $result2 = eval { Tie::IxHash::NEXTKEY($tie) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result2, 'b', 'NEXTKEY returns next key'); }

# Test case 3: Edge case with no more keys
my $result3 = eval { Tie::IxHash::NEXTKEY($tie) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result3, 'c', 'NEXTKEY returns last key'); }

# Test case 4: Edge case with no more keys (returns undef)
my $result4 = eval { Tie::IxHash::NEXTKEY($tie) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result4, undef, 'NEXTKEY returns undef when no more keys'); }

# Test case 5: Error handling with invalid input
my $result5 = eval { Tie::IxHash::NEXTKEY('invalid input') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result5, 'NEXTKEY handles invalid input'); }

done_testing();
