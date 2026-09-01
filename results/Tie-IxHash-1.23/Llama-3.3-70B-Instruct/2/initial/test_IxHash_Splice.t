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
$ixhash->Splice(0, 0, 'key1', 'value1');
$ixhash->Splice(1, 0, 'key2', 'value2');
my $result = eval { $ixhash->Splice(0, 1) };
if ($@) { fail('Splice crashed: ' . $@); } else { ok(defined $result, 'Splice returns result'); }
is($result[0], 'key1', 'Correct key returned');
is($result[1], 'value1', 'Correct value returned');

# Test case 2: Edge case - out of range start index
my $ixhash2 = tie my %hash2, 'Tie::IxHash';
$ixhash2->Splice(0, 0, 'key1', 'value1');
my $result2 = eval { $ixhash2->Splice(5, 1) };
if ($@) { fail('Splice crashed: ' . $@); } else { ok(defined $result2, 'Splice returns result for out of range start index'); }
is(@$result2, 0, 'No elements returned for out of range start index');

# Test case 3: Edge case - negative length
my $ixhash3 = tie my %hash3, 'Tie::IxHash';
$ixhash3->Splice(0, 0, 'key1', 'value1');
my $result3 = eval { $ixhash3->Splice(0, -1) };
if ($@) { fail('Splice crashed: ' . $@); } else { ok(defined $result3, 'Splice returns result for negative length'); }
is(@$result3, 0, 'No elements returned for negative length');

# Test case 4: Error handling - invalid inputs
my $ixhash4 = tie my %hash4, 'Tie::IxHash';
my $result4 = eval { $ixhash4->Splice('invalid_start', 1) };
if ($@) { fail('Splice crashed: ' . $@); } else { ok(defined $result4, 'Splice returns result for invalid start index'); }
is(@$result4, 0, 'No elements returned for invalid start index');

done_testing();
