use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::STORE"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'STORE is defined'); }

# Create a new Tie::IxHash object
my $ixhash = tie my %hash, 'Tie::IxHash';

# Test case 1: Store a new key-value pair
my $result = eval { Tie::IxHash::STORE($ixhash, 'key1', 'value1'); };
if ($@) { fail('STORE crashed: ' . $@); } else { ok(1, 'STORE new key-value pair'); }

# Test case 2: Store an existing key with a new value
$result = eval { Tie::IxHash::STORE($ixhash, 'key1', 'new_value1'); };
if ($@) { fail('STORE crashed: ' . $@); } else { ok(1, 'STORE existing key with new value'); }

# Test case 3: Store multiple key-value pairs
$result = eval { Tie::IxHash::STORE($ixhash, 'key2', 'value2'); };
if ($@) { fail('STORE crashed: ' . $@); } else { ok(1, 'STORE multiple key-value pairs'); }

# Test case 4: Store with invalid input (non-string key)
$result = eval { Tie::IxHash::STORE($ixhash, 123, 'value3'); };
if ($@) { fail('STORE crashed: ' . $@); } else { ok(1, 'STORE with invalid input (non-string key)'); }

# Test case 5: Store with invalid input (non-string value)
$result = eval { Tie::IxHash::STORE($ixhash, 'key4', 456); };
if ($@) { fail('STORE crashed: ' . $@); } else { ok(1, 'STORE with invalid input (non-string value)'); }

done_testing();
