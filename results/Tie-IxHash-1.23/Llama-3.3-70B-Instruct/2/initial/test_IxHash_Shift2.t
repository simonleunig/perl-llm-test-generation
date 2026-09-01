use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::Shift2"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'Shift2 is defined'); }

# Create a new Tie::IxHash object
my $ixhash = tie my %hash, 'Tie::IxHash';

# Test case: Shift from an empty hash
my $result = eval { $ixhash->Shift2() };
if ($@) { fail('Shift2 from empty hash crashed: ' . $@); } else { is($result, undef, 'Shift2 from empty hash returns undef'); }

# Test case: Shift from a non-empty hash
$ixhash->Push('key1', 'value1');
$ixhash->Push('key2', 'value2');
$result = eval { $ixhash->Shift2() };
if ($@) { fail('Shift2 from non-empty hash crashed: ' . $@); } else { is_deeply($result, ['key1', 'value1'], 'Shift2 from non-empty hash returns correct key-value pair'); }

# Test case: Shift from a hash with multiple key-value pairs
$ixhash->Push('key3', 'value3');
$result = eval { $ixhash->Shift2() };
if ($@) { fail('Shift2 from hash with multiple key-value pairs crashed: ' . $@); } else { is_deeply($result, ['key2', 'value2'], 'Shift2 from hash with multiple key-value pairs returns correct key-value pair'); }

# Test case: Shift from a hash after unshifting a new key-value pair
$ixhash->Unshift('new_key', 'new_value');
$result = eval { $ixhash->Shift2() };
if ($@) { fail('Shift2 from hash after unshifting crashed: ' . $@); } else { is_deeply($result, ['new_key', 'new_value'], 'Shift2 from hash after unshifting returns correct key-value pair'); }

done_testing();
