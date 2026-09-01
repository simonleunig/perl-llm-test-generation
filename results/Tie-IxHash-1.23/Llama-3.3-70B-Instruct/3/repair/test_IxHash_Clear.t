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

my $result = eval { Tie::IxHash::Clear($ixhash) };
if ($@) { fail('Clear crashed: ' . $@); } else { ok(1, 'Clear on empty IxHash succeeds'); }

eval { $ixhash->[1] = ['key1', 'key2']; $ixhash->[2] = ['value1', 'value2']; };
$result = eval { Tie::IxHash::Clear($ixhash) };
if ($@) { fail('Clear crashed: ' . $@); } else { ok(1, 'Clear after adding key-value pairs succeeds'); }
my $expected_keys = [];
my $expected_data = [];
is_deeply($ixhash->[1], $expected_keys, 'Array of keys is cleared');
is_deeply($ixhash->[2], $expected_data, 'Array of data is cleared');

my $invalid_input = 'not an IxHash object';
$result = eval { Tie::IxHash::Clear($invalid_input) };
if ($@) { ok(1, 'Clear with invalid input crashes as expected'); } else { fail('Clear with invalid input does not crash'); }

done_testing();