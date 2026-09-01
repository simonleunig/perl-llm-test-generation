use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::EXISTS"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'EXISTS is defined'); }

# Test case 1: Key exists in the hash
my $hash = tie my %hash, 'Tie::IxHash';
$hash->STORE('key', 'value');
my $result = eval { Tie::IxHash::EXISTS($hash, 'key') };
if ($@) { fail('Function crashed: ' . $@); } else { ok($result, 'Key exists in the hash'); }

# Test case 2: Key does not exist in the hash
$result = eval { Tie::IxHash::EXISTS($hash, 'non-existent-key') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!$result, 'Key does not exist in the hash'); }

# Test case 3: Key is not provided (undefined)
$result = eval { Tie::IxHash::EXISTS($hash, undef) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result, 'Key is not provided'); }

# Test case 4: Indexed hash object is not properly initialized
my $uninitialized_hash = bless {}, 'Tie::IxHash';
$result = eval { Tie::IxHash::EXISTS($uninitialized_hash, 'key') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result, 'Indexed hash object is not properly initialized'); }

done_testing();
