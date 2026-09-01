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

my $tie = tie my %hash, 'Tie::IxHash';

my $result = eval { $tie->Push2() };
if ($@) { fail('Push2 crashed with empty input: ' . $@); } else { is($result, 0, 'Push2 returns 0 with empty input'); }

$result = eval { $tie->Push2('key1', 'value1') };
if ($@) { fail('Push2 crashed with single key-value pair: ' . $@); } else { is($result, 1, 'Push2 returns 1 with single key-value pair'); }

$result = eval { $tie->Push2('key2', 'value2', 'key3', 'value3') };
if ($@) { fail('Push2 crashed with multiple key-value pairs: ' . $@); } else { is($result, 3, 'Push2 returns 3 with multiple key-value pairs'); }

my $error = eval { Tie::IxHash::Push2('invalid_input') };
if ($@) { like($@, qr/Can't use string .* as an ARRAY ref/, 'Push2 crashes with invalid input'); } else { fail('Push2 did not crash with invalid input'); }

done_testing();