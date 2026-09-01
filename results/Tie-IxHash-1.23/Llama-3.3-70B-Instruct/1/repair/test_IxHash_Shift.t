use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::Shift"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'Shift is defined'); }

my $ixhash = tie my %hash, 'Tie::IxHash';

my $result = eval { $ixhash->Shift() };
if ($@) { fail('Shift on empty hash crashed: ' . $@); } else { is($result, undef, 'Shift on empty hash returns undef'); }

$ixhash->Push('key1', 'value1');
$result = eval { $ixhash->Shift() };
if ($@) { fail('Shift on hash with one element crashed: ' . $@); } else { is_deeply($result, ['key1', 'value1'], 'Shift on hash with one element returns correct key-value pair'); }

$ixhash = tie my %hash2, 'Tie::IxHash';
$ixhash->Push('key1', 'value1');
$ixhash->Push('key2', 'value2');
$ixhash->Push('key3', 'value3');
$result = eval { $ixhash->Shift() };
if ($@) { fail('Shift on hash with multiple elements crashed: ' . $@); } else { is_deeply($result, ['key1', 'value1'], 'Shift on hash with multiple elements returns correct key-value pair'); }

done_testing();