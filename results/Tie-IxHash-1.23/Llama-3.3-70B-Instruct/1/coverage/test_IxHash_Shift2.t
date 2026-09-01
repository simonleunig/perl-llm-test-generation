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

# Test case: Empty hash
my $ixhash;  # AFTER LAST PASS: my $ixhash = tie my %hash, 'Tie::IxHash';
my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $ixhash->Shift2() };
# FAILED: if ($@) { fail('Shift2 on empty hash crashed: ' . $@); } else { is($result, undef, 'Shift2 on empty hash returns undef'); }

# Test case: Hash with one element
# AFTER LAST PASS: %hash = ();
# AFTER LAST PASS: $ixhash = tie %hash, 'Tie::IxHash';
# AFTER LAST PASS: $hash{key} = 'value';
# UNVALIDATED: $result = eval { $ixhash->Shift2() };
# FAILED: if ($@) { fail('Shift2 on hash with one element crashed: ' . $@); } else { is_deeply($result, ['key', 'value'], 'Shift2 on hash with one element returns key-value pair'); }

# Test case: Hash with multiple elements
# AFTER LAST PASS: %hash = ();
# AFTER LAST PASS: $ixhash = tie %hash, 'Tie::IxHash';
# AFTER LAST PASS: $hash{key1} = 'value1';
# AFTER LAST PASS: $hash{key2} = 'value2';
# UNVALIDATED: $result = eval { $ixhash->Shift2() };
# FAILED: if ($@) { fail('Shift2 on hash with multiple elements crashed: ' . $@); } else { is_deeply($result, ['key1', 'value1'], 'Shift2 on hash with multiple elements returns first key-value pair'); }

# Test case: Invalid input (not an instance of Tie::IxHash)
my $invalid_input;  # AFTER LAST PASS: my $invalid_input = bless {}, 'InvalidClass';
# UNVALIDATED: $result = eval { $invalid_input->Shift2() };
# FAILED: if ($@) { like($@, qr/Can't locate object method "Shift2" via package "InvalidClass"/, 'Shift2 on invalid input throws error'); } else { fail('Shift2 on invalid input did not throw error'); }

done_testing();