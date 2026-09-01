use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::Length"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'Length is defined'); }

# Create a Tie::IxHash object
my $ixhash = tie my %hash, 'Tie::IxHash';

# Test case: Empty hash
my $result = eval { Tie::IxHash::Length($ixhash) };
if ($@) { fail('Length function crashed: ' . $@); } else { is($result, 0, 'Length of empty hash is 0'); }

# Test case: Hash with one element
$hash{key1} = 'value1';
$result = eval { Tie::IxHash::Length($ixhash) };
if ($@) { fail('Length function crashed: ' . $@); } else { is($result, 1, 'Length of hash with one element is 1'); }

# Test case: Hash with multiple elements
$hash{key2} = 'value2';
$hash{key3} = 'value3';
$result = eval { Tie::IxHash::Length($ixhash) };
if ($@) { fail('Length function crashed: ' . $@); } else { is($result, 3, 'Length of hash with multiple elements is correct'); }

# Test case: Invalid input (not a Tie::IxHash object)
$result = eval { Tie::IxHash::Length('invalid input') };
if ($@) { ok(1, 'Length function crashes with invalid input'); } else { fail('Length function did not crash with invalid input'); }

done_testing();
