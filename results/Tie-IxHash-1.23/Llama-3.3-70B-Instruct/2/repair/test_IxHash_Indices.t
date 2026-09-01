use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::Indices"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'Indices is defined'); }

my $ixhash = tie my %hash, 'Tie::IxHash';
$hash{key1} = 'value1';
$hash{key2} = 'value2';
$hash{key3} = 'value3';

my $result = eval { Tie::IxHash::Indices($ixhash, 'key1') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, $hash{key1}, 'Single key returns correct value'); }

$result = eval { Tie::IxHash::Indices($ixhash, 'key1', 'key2') };
if ($@) { fail('Function crashed: ' . $@); } else { is_deeply($result, [$hash{key1}, $hash{key2}], 'Multiple keys return correct values'); }

$result = eval { Tie::IxHash::Indices($ixhash, 'non_existent_key') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, undef, 'Non-existent key returns undef'); }

$result = eval { Tie::IxHash::Indices($ixhash) };
if ($@) { fail('Function crashed: ' . $@); } else { is_deeply($result, [], 'No keys returns empty array'); }

done_testing();