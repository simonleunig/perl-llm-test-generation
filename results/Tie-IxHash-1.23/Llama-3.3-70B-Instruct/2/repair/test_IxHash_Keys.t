use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::Keys"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'Keys is defined'); }

my $tie = tie my %hash, 'Tie::IxHash';
$hash{a} = 1;
$hash{b} = 2;

my $result = eval { Tie::IxHash::Keys($tie, 0) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'a', 'Single index returns correct key'); }

$result = eval { Tie::IxHash::Keys($tie, 0, 1) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, ['a', 'b'], 'Multiple indices return correct keys'); }

$result = eval { Tie::IxHash::Keys($tie) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, ['a', 'b'], 'No indices return all keys'); }

$result = eval { Tie::IxHash::Keys($tie, 2) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, undef, 'Out-of-range index returns undef'); }

$result = eval { Tie::IxHash::Keys($tie, 'a') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, undef, 'Non-integer index returns undef'); }

done_testing();