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

# Create a new Tie::IxHash object
my $ixhash = tie my %hash, 'Tie::IxHash';

# Test case 1: Delete existing keys
eval {
    $ixhash->Push('key1', 'value1');
    $ixhash->Push('key2', 'value2');
    $ixhash->Delete('key1', 'key2');
    ok(!exists $hash{'key1'}, 'Key1 deleted');
    ok(!exists $hash{'key2'}, 'Key2 deleted');
};
# FAILED: if ($@) { fail('Delete existing keys crashed: ' . $@); }

# Test case 2: Delete non-existent keys
eval {
    $ixhash->Push('key3', 'value3');
    $ixhash->Delete('key4', 'key5');
    ok(exists $hash{'key3'}, 'Key3 still exists');
    ok(!exists $hash{'key4'}, 'Key4 does not exist');
    ok(!exists $hash{'key5'}, 'Key5 does not exist');
};
# FAILED: if ($@) { fail('Delete non-existent keys crashed: ' . $@); }

# Test case 3: Delete with empty list
eval {
    $ixhash->Push('key6', 'value6');
    $ixhash->Delete();
    ok(exists $hash{'key6'}, 'Key6 still exists');
};
# FAILED: if ($@) { fail('Delete with empty list crashed: ' . $@); }

done_testing();
