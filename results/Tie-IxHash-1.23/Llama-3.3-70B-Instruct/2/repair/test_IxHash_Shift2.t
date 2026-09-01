use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::Shift2"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'Shift2 is defined'); }

my $ixhash = tie my %hash, 'Tie::IxHash';

my $result = eval { $ixhash->Shift2() };
if ($@) { fail('Shift2 from empty hash crashed: ' . $@); } else { is($result, undef, 'Shift2 from empty hash returns undef'); }

$ixhash->Push('key1', 'value1');
$ixhash->Push('key2', 'value2');
$result = eval { $ixhash->Shift2() };
if ($@) { fail('Shift2 from non-empty hash crashed: ' . $@); } else { is_deeply($result, ['key1', 'value1'], 'Shift2 from non-empty hash returns correct key-value pair'); }

$ixhash->Push('key3', 'value3');
$result = eval { $ixhash->Shift2() };
if ($@) { fail('Shift2 from hash with multiple key-value pairs crashed: ' . $@); } else { is_deeply($result, ['key2', 'value2'], 'Shift2 from hash with multiple key-value pairs returns correct key-value pair'); }

$ixhash->Unshift('new_key', 'new_value');
$result = eval { $ixhash->Shift2() };
if ($@) { fail('Shift2 from hash after unshifting crashed: ' . $@); } else { is_deeply($result, ['new_key', 'new_value'], 'Shift2 from hash after unshifting returns correct key-value pair'); }

done_testing();