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

# Create a Tie::IxHash object
my $ixhash = tie my %hash, 'Tie::IxHash';

# Test case 1: Delete existing keys
my $result = eval { $ixhash->Delete('key1', 'key2') };
if ($@) { fail('Delete crashed: ' . $@); } else { ok(1, 'Delete existing keys'); }

# Test case 2: Delete non-existing keys
$result = eval { $ixhash->Delete('non_existent_key') };
if ($@) { fail('Delete crashed: ' . $@); } else { ok(1, 'Delete non-existing keys'); }

# Test case 3: Delete multiple existing keys
$hash{'key3'} = 'value3';
$hash{'key4'} = 'value4';
$result = eval { $ixhash->Delete('key3', 'key4') };
if ($@) { fail('Delete crashed: ' . $@); } else { ok(1, 'Delete multiple existing keys'); }

# Test case 4: Delete all keys
$hash{'key5'} = 'value5';
$hash{'key6'} = 'value6';
$result = eval { $ixhash->Delete('key5', 'key6') };
if ($@) { fail('Delete crashed: ' . $@); } else { ok(1, 'Delete all keys'); }

# Test case 5: Delete no keys (empty list)
$result = eval { $ixhash->Delete() };
if ($@) { fail('Delete crashed: ' . $@); } else { ok(1, 'Delete no keys'); }

done_testing();
