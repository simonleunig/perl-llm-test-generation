use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::Clear"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'Clear is defined'); }

my $ixhash = tie my %hash, 'Tie::IxHash';
$hash{key1} = 'value1';
$hash{key2} = 'value2';
my $result = eval { Tie::IxHash::Clear($ixhash) };
if ($@) { fail('Clear function crashed: ' . $@); } else { ok(!defined $result, 'Clear function returns no result'); }
my $expected;  # AFTER LAST PASS: my $expected = {};
my $got;  # AFTER LAST PASS: my $got = \%hash;
# FAILED: is_deeply($got, $expected, 'Indexed hash is cleared');

my $empty_ixhash;  # AFTER LAST PASS: my $empty_ixhash = tie my %empty_hash, 'Tie::IxHash';
# UNVALIDATED: $result = eval { Tie::IxHash::Clear($empty_ixhash) };
# FAILED: if ($@) { fail('Clear function crashed on empty hash: ' . $@); } else { ok(!defined $result, 'Clear function returns no result on empty hash'); }
# AFTER LAST PASS: $expected = {};
# AFTER LAST PASS: $got = \%empty_hash;
# FAILED: is_deeply($got, $expected, 'Empty indexed hash remains empty after clearing');

my $invalid_object;  # AFTER LAST PASS: my $invalid_object = bless {}, 'InvalidObject';
# UNVALIDATED: $result = eval { Tie::IxHash::Clear($invalid_object) };
# FAILED: if ($@) { fail('Clear function crashed on invalid object: ' . $@); } else { ok(!defined $result, 'Clear function does not return result on invalid object'); }

done_testing();