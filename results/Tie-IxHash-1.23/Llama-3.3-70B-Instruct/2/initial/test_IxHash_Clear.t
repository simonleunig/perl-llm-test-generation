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

# Test case 1: Successful clearing of an indexed hash object
my $ixhash = tie my %hash, 'Tie::IxHash';
$hash{key1} = 'value1';
$hash{key2} = 'value2';
my $result = eval { Tie::IxHash::Clear($ixhash) };
if ($@) { fail('Clear function crashed: ' . $@); } else { ok(defined $result, 'Clear function returns result'); }
is_deeply(\%hash, {}, 'Indexed hash is cleared');

# Test case 2: Clearing an empty indexed hash object
my $empty_ixhash = tie my %empty_hash, 'Tie::IxHash';
$result = eval { Tie::IxHash::Clear($empty_ixhash) };
if ($@) { fail('Clear function crashed on empty hash: ' . $@); } else { ok(defined $result, 'Clear function returns result on empty hash'); }
is_deeply(\%empty_hash, {}, 'Empty indexed hash remains empty after clearing');

# Test case 3: Passing an invalid object to the Clear function
my $invalid_object = bless {}, 'InvalidObject';
$result = eval { Tie::IxHash::Clear($invalid_object) };
if ($@) { fail('Clear function crashed on invalid object: ' . $@); } else { ok(!defined $result, 'Clear function does not return result on invalid object'); }

done_testing();
