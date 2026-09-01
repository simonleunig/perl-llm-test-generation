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

# Test case 1: Empty hash
my $tie = tie my %hash, 'Tie::IxHash';
my $result = eval { $tie->SortByValue(); };
if ($@) { fail('SortByValue crashed on empty hash: ' . $@); } else { ok(1, 'SortByValue on empty hash succeeds'); }

# Test case 2: Hash with single element
%hash = ();
$tie = tie %hash, 'Tie::IxHash';
$hash{a} = 'b';
$result = eval { $tie->SortByValue(); };
if ($@) { fail('SortByValue crashed on single-element hash: ' . $@); } else { ok(1, 'SortByValue on single-element hash succeeds'); }

# Test case 3: Hash with multiple elements
%hash = ();
$tie = tie %hash, 'Tie::IxHash';
$hash{c} = 'a';
$hash{b} = 'c';
$hash{a} = 'b';
$result = eval { $tie->SortByValue(); };
if ($@) { fail('SortByValue crashed on multi-element hash: ' . $@); } else { ok(1, 'SortByValue on multi-element hash succeeds'); }

# Test case 4: Hash with duplicate values
%hash = ();
$tie = tie %hash, 'Tie::IxHash';
$hash{a} = 'b';
$hash{c} = 'b';
$hash{b} = 'a';
$result = eval { $tie->SortByValue(); };
if ($@) { fail('SortByValue crashed on hash with duplicate values: ' . $@); } else { ok(1, 'SortByValue on hash with duplicate values succeeds'); }

done_testing();
