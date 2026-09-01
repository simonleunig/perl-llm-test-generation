use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::Push2"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'Push2 is defined'); }

my $ixhash = tie my %hash, 'Tie::IxHash';

my $result = eval { $ixhash->Push2('key1' => 'value1', 'key2' => 'value2') };
if ($@) { fail('Push2 crashed: ' . $@); } else { is($result, 2, 'Push2 returns correct count'); }

$result = eval { $ixhash->Push2('key3' => 'value3', 'key4' => 'value4') };
if ($@) { fail('Push2 crashed: ' . $@); } else { is($result, 4, 'Push2 returns correct count'); }

$result = eval { $ixhash->Push2() };
if ($@) { fail('Push2 crashed: ' . $@); } else { is($result, 4, 'Push2 returns correct count'); }

my $invalid_ixhash = bless {}, 'Tie::IxHash';
$result = eval { $invalid_ixhash->Push2('key5' => 'value5') };
if ($@) { ok(1, 'Push2 handles invalid input'); } else { fail('Push2 did not handle invalid input'); }

done_testing();