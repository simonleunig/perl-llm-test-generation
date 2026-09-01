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
my $result1 = eval { Tie::IxHash->TIEHASH() };
if ($@) { fail('TIEHASH crashed without key-value pairs: ' . $@); } else { ok(defined $result1, 'TIEHASH returns result without key-value pairs'); }

# Test case 2: Create a new Tie::IxHash object with key-value pairs
my $result2 = eval { Tie::IxHash->TIEHASH('key1' => 'value1', 'key2' => 'value2') };
if ($@) { fail('TIEHASH crashed with key-value pairs: ' . $@); } else { ok(defined $result2, 'TIEHASH returns result with key-value pairs'); }

# Test case 3: Check the internal data structures of the Tie::IxHash object
my $ixhash = Tie::IxHash->TIEHASH();
my $hash_key_index = $ixhash->[0];
my $array_of_keys = $ixhash->[1];
my $array_of_data = $ixhash->[2];
my $iter_count = $ixhash->[3];
ok(ref $hash_key_index eq 'HASH', 'Hash key index is a hash reference');
ok(ref $array_of_keys eq 'ARRAY', 'Array of keys is an array reference');
ok(ref $array_of_data eq 'ARRAY', 'Array of data is an array reference');
ok($iter_count == 0, 'Iteration count is initialized to 0');

done_testing();
