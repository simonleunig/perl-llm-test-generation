use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::Unshift2"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'Unshift2 is defined'); }

my $tie = tie my %hash, 'Tie::IxHash';
my $result = eval { Tie::IxHash::Unshift2($tie) };
if ($@) { fail('Unshift2 crashed with empty input: ' . $@); } else { is($result, 0, 'Unshift2 returns 0 with empty input'); }

%hash = ();
$tie = tie %hash, 'Tie::IxHash';
$result = eval { Tie::IxHash::Unshift2($tie, 'key1', 'value1', 'key2', 'value2') };
if ($@) { fail('Unshift2 crashed with non-empty input: ' . $@); } else { is($result, 2, 'Unshift2 returns correct count with non-empty input'); }

%hash = ();
$tie = tie %hash, 'Tie::IxHash';
$result = eval { Tie::IxHash::Unshift2($tie, 'key1', 'value1', 'key1', 'new_value') };
if ($@) { fail('Unshift2 crashed with duplicate keys: ' . $@); } else { is($result, 1, 'Unshift2 returns correct count with duplicate keys'); }

%hash = ();
$tie = tie %hash, 'Tie::IxHash';
$result = eval { Tie::IxHash::Unshift2($tie, 'key1', 'value1', 'key2', 'value2') };
if ($@) { fail('Unshift2 crashed with new keys: ' . $@); } else { is($result, 2, 'Unshift2 returns correct count with new keys'); }

done_testing();