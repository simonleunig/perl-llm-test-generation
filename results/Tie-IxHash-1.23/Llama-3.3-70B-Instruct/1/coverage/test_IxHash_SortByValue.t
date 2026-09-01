use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::SortByValue"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'SortByValue is defined'); }

# Create a new Tie::IxHash object
my $ixhash = tie my %hash, 'Tie::IxHash';

# Test case 1: Empty hash
my $result = eval { $ixhash->SortByValue(); };
if ($@) { fail('SortByValue crashed on empty hash: ' . $@); } else { ok(1, 'SortByValue on empty hash succeeds'); }

# Test case 2: Hash with single element
%hash = ();
$ixhash->STORE('key1', 'value1');
$result = eval { $ixhash->SortByValue(); };
if ($@) { fail('SortByValue crashed on single-element hash: ' . $@); } else { ok(1, 'SortByValue on single-element hash succeeds'); }

# Test case 3: Hash with multiple elements
%hash = ();
$ixhash->STORE('key1', 'value1');
$ixhash->STORE('key2', 'value2');
$ixhash->STORE('key3', 'value3');
$result = eval { $ixhash->SortByValue(); };
if ($@) { fail('SortByValue crashed on multi-element hash: ' . $@); } else { ok(1, 'SortByValue on multi-element hash succeeds'); }

# Test case 4: Hash with equal values
%hash = ();
$ixhash->STORE('key1', 'value1');
$ixhash->STORE('key2', 'value1');
$ixhash->STORE('key3', 'value1');
$result = eval { $ixhash->SortByValue(); };
if ($@) { fail('SortByValue crashed on hash with equal values: ' . $@); } else { ok(1, 'SortByValue on hash with equal values succeeds'); }

# Test case 5: Hash with non-comparable values
%hash = ();
$ixhash->STORE('key1', 1);
$ixhash->STORE('key2', 2);
$ixhash->STORE('key3', 3);
$result = eval { $ixhash->SortByValue(); };
if ($@) { fail('SortByValue crashed on hash with non-comparable values: ' . $@); } else { ok(1, 'SortByValue on hash with non-comparable values succeeds'); }

done_testing();
