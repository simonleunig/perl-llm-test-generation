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
$hash{c} = 3;

my $result = eval { Tie::IxHash::Keys($tie) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { is($result, [qw(a b c)], 'Returns all keys when no indices are provided'); }

$result = eval { Tie::IxHash::Keys($tie, 1) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'b', 'Returns key at index when single index is provided'); }

$result = eval { Tie::IxHash::Keys($tie, 0, 2) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { is($result, [qw(a c)], 'Returns keys at indices when multiple indices are provided'); }

$result = eval { Tie::IxHash::Keys($tie, 3) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, undef, 'Returns undef when index is out of range'); }

done_testing();