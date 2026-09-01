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

# Test case 1: Create a new Tie::IxHash object without key-value pairs
my $result = eval { Tie::IxHash->TIEHASH('Tie::IxHash') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }

# Test case 2: Create a new Tie::IxHash object with key-value pairs
$result = eval { Tie::IxHash->TIEHASH('Tie::IxHash', 'key1' => 'value1', 'key2' => 'value2') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result with key-value pairs'); }

# Test case 3: Check the structure of the Tie::IxHash object
$result = eval { Tie::IxHash->TIEHASH('Tie::IxHash') };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(ref($result) eq 'Tie::IxHash', 'Object is a Tie::IxHash');
    ok(ref($result->[0]) eq 'HASH', 'First element is a hash');
    ok(ref($result->[1]) eq 'ARRAY', 'Second element is an array');
    ok(ref($result->[2]) eq 'ARRAY', 'Third element is an array');
    ok($result->[3] == 0, 'Fourth element is an iteration count');
}

done_testing();
