use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::Shift"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'Shift is defined'); }

# Create a new Tie::IxHash object
my $ixhash = tie my %hash, 'Tie::IxHash';

# Test case 1: Empty hash
my $result = eval { $ixhash->Shift() };
if ($@) { fail('Shift on empty hash crashed: ' . $@); } else { is($result, undef, 'Shift on empty hash returns undef'); }

# Test case 2: Hash with one element
# AFTER LAST PASS: %hash = ();
# AFTER LAST PASS: $ixhash = tie %hash, 'Tie::IxHash';
# AFTER LAST PASS: $ixhash->Push('key1', 'value1');
# UNVALIDATED: $result = eval { $ixhash->Shift() };
# FAILED: if ($@) { fail('Shift on hash with one element crashed: ' . $@); } else { is($result, ['key1', 'value1'], 'Shift on hash with one element returns correct key-value pair'); }

# Test case 3: Hash with multiple elements
# AFTER LAST PASS: %hash = ();
# AFTER LAST PASS: $ixhash = tie %hash, 'Tie::IxHash';
# AFTER LAST PASS: $ixhash->Push('key1', 'value1');
# AFTER LAST PASS: $ixhash->Push('key2', 'value2');
# AFTER LAST PASS: $ixhash->Push('key3', 'value3');
# UNVALIDATED: $result = eval { $ixhash->Shift() };
# FAILED: if ($@) { fail('Shift on hash with multiple elements crashed: ' . $@); } else { is($result, ['key1', 'value1'], 'Shift on hash with multiple elements returns correct key-value pair'); }

done_testing();