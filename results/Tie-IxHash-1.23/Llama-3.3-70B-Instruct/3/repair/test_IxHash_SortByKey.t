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

# Test case 1: Empty IxHash
my $ixhash = tie my %hash, 'Tie::IxHash';
my $result = eval { $ixhash->SortByKey(); };
if ($@) { fail('SortByKey on empty IxHash crashed: ' . $@); } else { ok(1, 'SortByKey on empty IxHash succeeds'); }

# Test case 2: IxHash with single element
%hash = ();
$ixhash = tie %hash, 'Tie::IxHash';
$hash{a} = 1;
$result = eval { $ixhash->SortByKey(); };
if ($@) { fail('SortByKey on single-element IxHash crashed: ' . $@); } else { ok(1, 'SortByKey on single-element IxHash succeeds'); }

# Test case 3: IxHash with multiple elements
%hash = ();
$ixhash = tie %hash, 'Tie::IxHash';
$hash{c} = 3;
$hash{a} = 1;
$hash{b} = 2;
$result = eval { $ixhash->SortByKey(); };
if ($@) { fail('SortByKey on multi-element IxHash crashed: ' . $@); } else { ok(1, 'SortByKey on multi-element IxHash succeeds'); }
my @keys = $ixhash->Keys;
is(\@keys, [qw(a b c)], 'Keys are sorted correctly');

# Test case 4: IxHash with duplicate keys (not applicable for hashes)
# Test case 5: IxHash with non-comparable keys (e.g., non-string, non-numeric)
%hash = ();
$ixhash = tie %hash, 'Tie::IxHash';
$hash{1} = 'one';
$hash{0} = 'zero';
$result = eval { $ixhash->SortByKey(); };
if ($@) { fail('SortByKey on IxHash with non-comparable keys crashed: ' . $@); } else { ok(1, 'SortByKey on IxHash with non-comparable keys succeeds'); }
@keys = $ixhash->Keys;
is(\@keys, [qw(0 1)], 'Keys are sorted correctly');

done_testing();
