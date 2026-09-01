use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::Clear"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'Clear is defined'); }

# Create a new Tie::IxHash object
my $ixhash = tie my %hash, 'Tie::IxHash';

# Test case 1: Clear an empty IxHash
my $result = eval { Tie::IxHash::Clear($ixhash) };
if ($@) { fail('Clear crashed: ' . $@); } else { ok(1, 'Clear on empty IxHash succeeds'); }

# Test case 2: Add some key-value pairs and then clear
eval { $ixhash->[1] = ['key1', 'key2']; $ixhash->[2] = ['value1', 'value2']; };
$result = eval { Tie::IxHash::Clear($ixhash) };
if ($@) { fail('Clear crashed: ' . $@); } else { ok(1, 'Clear after adding key-value pairs succeeds'); }
is_deeply($ixhash->[1], [], 'Array of keys is cleared');
is_deeply($ixhash->[2], [], 'Array of data is cleared');

# Test case 3: Clear with invalid input
my $invalid_input = 'not an IxHash object';
$result = eval { Tie::IxHash::Clear($invalid_input) };
if ($@) { ok(1, 'Clear with invalid input crashes as expected'); } else { fail('Clear with invalid input does not crash'); }

done_testing();
