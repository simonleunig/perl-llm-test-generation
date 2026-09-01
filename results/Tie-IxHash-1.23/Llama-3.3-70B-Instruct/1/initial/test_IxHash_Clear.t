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

# Test case 1: Normal operation
my $ixhash = tie my %hash, 'Tie::IxHash';
$hash{a} = 1;
$hash{b} = 2;
my $result = eval { Tie::IxHash::Clear($ixhash) };
if ($@) { fail('Clear crashed: ' . $@); } else { ok(defined $result, 'Clear returns result'); }
is(keys %hash, 0, 'Hash is empty after Clear');

# Test case 2: Edge case - empty hash
my $empty_ixhash = tie my %empty_hash, 'Tie::IxHash';
my $empty_result = eval { Tie::IxHash::Clear($empty_ixhash) };
if ($@) { fail('Clear on empty hash crashed: ' . $@); } else { ok(defined $empty_result, 'Clear on empty hash returns result'); }
is(keys %empty_hash, 0, 'Empty hash remains empty after Clear');

# Test case 3: Error handling - invalid input
my $invalid_result = eval { Tie::IxHash::Clear('invalid_input') };
if ($@) { ok(1, 'Clear with invalid input crashes as expected'); } else { fail('Clear with invalid input did not crash'); }

done_testing();
