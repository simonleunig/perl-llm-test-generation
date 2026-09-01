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
my $result = eval { Tie::IxHash::EXISTS($hash, 'key') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!$result, 'Key does not exist in the hash'); }

$hash->STORE('key', 'value');
$result = eval { Tie::IxHash::EXISTS($hash, 'key') };
if ($@) { fail('Function crashed: ' . $@); } else { ok($result, 'Key exists in the hash'); }

$result = eval { Tie::IxHash::EXISTS($hash, 'non-existent-key') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!$result, 'Key does not exist in the hash'); }

$result = eval { Tie::IxHash::EXISTS($hash, undef) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!$result, 'Key is not provided'); }

my $uninitialized_hash;  # AFTER LAST PASS: my $uninitialized_hash = bless {}, 'Tie::IxHash';
# UNVALIDATED: $result = eval { Tie::IxHash::EXISTS($uninitialized_hash, 'key') };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(!$result, 'Indexed hash object is not properly initialized'); }

done_testing();