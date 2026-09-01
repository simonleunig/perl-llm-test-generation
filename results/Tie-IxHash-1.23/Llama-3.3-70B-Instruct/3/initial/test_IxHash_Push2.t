use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::Push2"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'Push2 is defined'); }

# Create a new Tie::IxHash object
my $ixhash = tie my %hash, 'Tie::IxHash';

# Test case 1: Add key-value pairs to an empty indexed hash
my $result = eval { Tie::IxHash->Push2($ixhash, 'key1' => 'value1', 'key2' => 'value2') };
if ($@) { fail('Push2 crashed: ' . $@); } else { is($result, 2, 'Added 2 key-value pairs to an empty indexed hash'); }

# Test case 2: Add key-value pairs to a non-empty indexed hash
$result = eval { Tie::IxHash->Push2($ixhash, 'key3' => 'value3', 'key4' => 'value4') };
if ($@) { fail('Push2 crashed: ' . $@); } else { is($result, 4, 'Added 2 key-value pairs to a non-empty indexed hash'); }

# Test case 3: Add no key-value pairs (empty list)
$result = eval { Tie::IxHash->Push2($ixhash) };
if ($@) { fail('Push2 crashed: ' . $@); } else { is($result, 4, 'Added no key-value pairs'); }

# Test case 4: Error handling - pass an invalid object
my $invalid_object = bless {}, 'InvalidObject';
$result = eval { Tie::IxHash->Push2($invalid_object, 'key5' => 'value5') };
if ($@) { ok(1, 'Push2 failed with an invalid object'); } else { fail('Push2 did not fail with an invalid object'); }

done_testing();
