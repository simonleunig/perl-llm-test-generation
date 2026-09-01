use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::TIEHASH"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'TIEHASH is defined'); }

# Test case 1: Create a new Tie::IxHash object with no initial key-value pairs
my $result = eval { Tie::IxHash->TIEHASH('Tie::IxHash') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }

# Test case 2: Create a new Tie::IxHash object with initial key-value pairs
$result = eval { Tie::IxHash->TIEHASH('Tie::IxHash', 'key1' => 'value1', 'key2' => 'value2') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }

# Test case 3: Create a new Tie::IxHash object with an odd number of initial key-value pairs
$result = eval { Tie::IxHash->TIEHASH('Tie::IxHash', 'key1' => 'value1', 'key2' => 'value2', 'key3') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }

done_testing();
