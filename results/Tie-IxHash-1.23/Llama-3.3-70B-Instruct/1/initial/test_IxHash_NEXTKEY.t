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

# Test case 1: Normal iteration
my $tie = tie my %hash, 'Tie::IxHash';
$hash{a} = 1;
$hash{b} = 2;
$hash{c} = 3;
my $result = eval { Tie::IxHash::NEXTKEY($tie) };
if ($@) { fail('NEXTKEY crashed: ' . $@); } else { is($result, 'a', 'NEXTKEY returns first key'); }

# Test case 2: Iteration after first key
$tie->[3] = 0; # reset index
$result = eval { Tie::IxHash::NEXTKEY($tie) };
if ($@) { fail('NEXTKEY crashed: ' . $@); } else { is($result, 'a', 'NEXTKEY returns first key again'); }
$result = eval { Tie::IxHash::NEXTKEY($tie) };
if ($@) { fail('NEXTKEY crashed: ' . $@); } else { is($result, 'b', 'NEXTKEY returns second key'); }

# Test case 3: Iteration after last key
$tie->[3] = 2; # set index to last key
$result = eval { Tie::IxHash::NEXTKEY($tie) };
if ($@) { fail('NEXTKEY crashed: ' . $@); } else { is($result, 'c', 'NEXTKEY returns last key'); }
$result = eval { Tie::IxHash::NEXTKEY($tie) };
if ($@) { fail('NEXTKEY crashed: ' . $@); } else { is($result, undef, 'NEXTKEY returns undef after last key'); }

# Test case 4: Edge case - empty hash
untie %hash;
tie %hash, 'Tie::IxHash';
$result = eval { Tie::IxHash::NEXTKEY($tie) };
if ($@) { fail('NEXTKEY crashed: ' . $@); } else { is($result, undef, 'NEXTKEY returns undef for empty hash'); }

done_testing();
