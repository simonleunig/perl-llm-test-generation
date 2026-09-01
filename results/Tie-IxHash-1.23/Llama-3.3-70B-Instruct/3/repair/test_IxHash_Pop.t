use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::Pop"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'Pop is defined'); }

my $ixhash = tie my %hash, 'Tie::IxHash';

my $result = eval { $ixhash->Pop() };
if ($@) { fail('Pop crashed on empty hash: ' . $@); } else { is($result, undef, 'Pop returns undef on empty hash'); }

$ixhash->Push('key1', 'value1');
$result = eval { $ixhash->Pop() };
if ($@) { fail('Pop crashed on hash with one element: ' . $@); } else { is($result, ['key1', 'value1'], 'Pop returns correct key-value pair on hash with one element'); }

$ixhash->Push('key2', 'value2');
$ixhash->Push('key3', 'value3');
$result = eval { $ixhash->Pop() };
if ($@) { fail('Pop crashed on hash with multiple elements: ' . $@); } else { is($result, ['key3', 'value3'], 'Pop returns correct key-value pair on hash with multiple elements'); }

$result = eval { $ixhash->Pop() };
if ($@) { fail('Pop crashed on second Pop operation: ' . $@); } else { is($result, ['key2', 'value2'], 'Pop returns correct key-value pair on second Pop operation'); }
$result = eval { $ixhash->Pop() };
if ($@) { fail('Pop crashed on third Pop operation: ' . $@); } else { is($result, undef, 'Pop returns undef on third Pop operation'); }

done_testing();