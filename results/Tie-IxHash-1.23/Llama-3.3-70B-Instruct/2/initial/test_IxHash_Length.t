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

# Test case: Empty hash
my $empty_hash = tie my %hash, 'Tie::IxHash';
my $result = eval { Tie::IxHash::Length($empty_hash) };
if ($@) { fail('Length function crashed on empty hash: ' . $@); } else { is($result, 0, 'Length of empty hash is 0'); }

# Test case: Hash with one element
$empty_hash = tie my %hash, 'Tie::IxHash';
$hash{key} = 'value';
$result = eval { Tie::IxHash::Length($empty_hash) };
if ($@) { fail('Length function crashed on hash with one element: ' . $@); } else { is($result, 1, 'Length of hash with one element is 1'); }

# Test case: Hash with multiple elements
$empty_hash = tie my %hash, 'Tie::IxHash';
$hash{key1} = 'value1';
$hash{key2} = 'value2';
$hash{key3} = 'value3';
$result = eval { Tie::IxHash::Length($empty_hash) };
if ($@) { fail('Length function crashed on hash with multiple elements: ' . $@); } else { is($result, 3, 'Length of hash with multiple elements is 3'); }

# Test case: Invalid input (not a hash reference)
$result = eval { Tie::IxHash::Length('not a hash reference') };
if ($@) { ok(1, 'Length function crashed on invalid input'); } else { fail('Length function did not crash on invalid input'); }

done_testing();
