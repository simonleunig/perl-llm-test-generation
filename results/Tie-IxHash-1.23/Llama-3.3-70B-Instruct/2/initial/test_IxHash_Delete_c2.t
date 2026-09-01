use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::Delete"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'Delete is defined'); }

# Test case 1: Delete existing keys
my $ixhash = tie my %hash, 'Tie::IxHash';
$ixhash->Push('key1', 'value1');
$ixhash->Push('key2', 'value2');
my $result = eval { $ixhash->Delete('key1', 'key2') };
if ($@) { fail('Delete crashed: ' . $@); } else { ok(1, 'Delete existing keys'); }

# Test case 2: Delete non-existing keys
$ixhash = tie %hash, 'Tie::IxHash';
$ixhash->Push('key1', 'value1');
$result = eval { $ixhash->Delete('key2', 'key3') };
if ($@) { fail('Delete crashed: ' . $@); } else { ok(1, 'Delete non-existing keys'); }

# Test case 3: Delete empty list
$ixhash = tie %hash, 'Tie::IxHash';
$ixhash->Push('key1', 'value1');
$result = eval { $ixhash->Delete() };
if ($@) { fail('Delete crashed: ' . $@); } else { ok(1, 'Delete empty list'); }

# Test case 4: Delete with less than 4 keys
$ixhash = tie %hash, 'Tie::IxHash';
$ixhash->Push('key1', 'value1');
$ixhash->Push('key2', 'value2');
$ixhash->Push('key3', 'value3');
$result = eval { $ixhash->Delete('key1', 'key2') };
if ($@) { fail('Delete crashed: ' . $@); } else { ok(1, 'Delete with less than 4 keys'); }

done_testing();
