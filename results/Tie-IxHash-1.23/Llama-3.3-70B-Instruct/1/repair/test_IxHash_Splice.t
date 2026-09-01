use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::Splice"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'Splice is defined'); }

# Test case 1: Normal splice operation
my $ixhash = tie my %hash, 'Tie::IxHash';
$ixhash->Splice(0, 0, 'key1', 'value1', 'key2', 'value2');
my @expected = ('key1', 'value1', 'key2', 'value2');
my @result = $ixhash->Splice(0, 2);
is(\@result, \@expected, 'Normal splice operation');

# Test case 2: Edge case - negative length
my $result = eval { $ixhash->Splice(0, -1) };
if ($@) { fail('Negative length crashed: ' . $@); } else { ok(1, 'Negative length did not crash'); }

# Test case 3: Edge case - out of range start index
$result = eval { $ixhash->Splice(10, 1) };
if ($@) { fail('Out of range start index crashed: ' . $@); } else { ok(1, 'Out of range start index did not crash'); }

# Test case 4: Error handling - invalid input
$result = eval { $ixhash->Splice('invalid', 1) };
if ($@) { fail('Invalid input crashed: ' . $@); } else { ok(1, 'Invalid input did not crash'); }

done_testing();
