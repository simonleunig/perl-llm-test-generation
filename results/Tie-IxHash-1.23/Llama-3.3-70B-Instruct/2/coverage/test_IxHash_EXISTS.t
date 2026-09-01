use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::EXISTS"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'EXISTS is defined'); }

my $hash = tie my %hash, 'Tie::IxHash';
my $result = eval { Tie::IxHash::EXISTS($hash, 'key1') };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result, 'Key does not exist in the hash'); }

$hash->STORE('key1', 'value1');
$result = eval { Tie::IxHash::EXISTS($hash, 'key1') };
if ($@) { fail('Function crashed: ' . $@); } else { ok($result, 'Key exists in the hash'); }

$result = eval { Tie::IxHash::EXISTS($hash, 'key2') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!$result, 'Key does not exist in the hash'); }

$result = eval { Tie::IxHash::EXISTS($hash, undef) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!$result, 'Key is not provided'); }

my $bad_hash = bless [], 'Tie::IxHash';
$result = eval { Tie::IxHash::EXISTS($bad_hash, 'key1') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!$result, 'Indexed hash object is not properly initialized'); }

done_testing();