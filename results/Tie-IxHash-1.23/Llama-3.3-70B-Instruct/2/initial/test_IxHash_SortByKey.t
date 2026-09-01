use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::SortByKey"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'SortByKey is defined'); }

# Create a new Tie::IxHash object
my $ixhash = tie my %hash, 'Tie::IxHash';

# Test case 1: Empty IxHash
my $result = eval { $ixhash->SortByKey(); };
if ($@) { fail('SortByKey crashed on empty IxHash: ' . $@); } else { ok(1, 'SortByKey on empty IxHash succeeds'); }

# Test case 2: IxHash with single element
%hash = ();
$ixhash->Push('key1', 'value1');
$result = eval { $ixhash->SortByKey(); };
if ($@) { fail('SortByKey crashed on single-element IxHash: ' . $@); } else { ok(1, 'SortByKey on single-element IxHash succeeds'); }

# Test case 3: IxHash with multiple elements
%hash = ();
$ixhash->Push('key3', 'value3');
$ixhash->Push('key1', 'value1');
$ixhash->Push('key2', 'value2');
$result = eval { $ixhash->SortByKey(); };
if ($@) { fail('SortByKey crashed on multi-element IxHash: ' . $@); } else { ok(1, 'SortByKey on multi-element IxHash succeeds'); }

# Test case 4: IxHash with duplicate keys (not applicable for IxHash)
# IxHash does not allow duplicate keys, so this test case is not applicable

# Test case 5: IxHash with non-comparable keys
%hash = ();
$ixhash->Push(3, 'value3');
$ixhash->Push(1, 'value1');
$ixhash->Push(2, 'value2');
$result = eval { $ixhash->SortByKey(); };
if ($@) { fail('SortByKey crashed on IxHash with non-comparable keys: ' . $@); } else { ok(1, 'SortByKey on IxHash with non-comparable keys succeeds'); }

done_testing();
