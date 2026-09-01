use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::Push"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'Push is defined'); }

# Create a new Tie::IxHash object
my $ixhash = tie my %hash, 'Tie::IxHash';

# Test case 1: Empty list
my $result = eval { Tie::IxHash::Push($ixhash) };
if ($@) { fail('Push crashed with empty list: ' . $@); } else { is($result, 0, 'Push returns 0 with empty list'); }

# Test case 2: Single key-value pair
$result = eval { Tie::IxHash::Push($ixhash, 'key1', 'value1') };
if ($@) { fail('Push crashed with single key-value pair: ' . $@); } else { is($result, 1, 'Push returns 1 with single key-value pair'); }

# Test case 3: Multiple key-value pairs
$result = eval { Tie::IxHash::Push($ixhash, 'key2', 'value2', 'key3', 'value3') };
if ($@) { fail('Push crashed with multiple key-value pairs: ' . $@); } else { is($result, 3, 'Push returns 3 with multiple key-value pairs'); }

# Test case 4: Duplicate key
$result = eval { Tie::IxHash::Push($ixhash, 'key2', 'new_value') };
if ($@) { fail('Push crashed with duplicate key: ' . $@); } else { is($result, 3, 'Push returns 3 with duplicate key'); }

# Test case 5: Invalid input (non-key-value pair arguments)
$result = eval { Tie::IxHash::Push($ixhash, 'key4') };
if ($@) { fail('Push crashed with invalid input: ' . $@); } else { ok(defined $result, 'Push returns result with invalid input'); }

done_testing();
