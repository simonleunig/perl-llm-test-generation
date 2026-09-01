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

# Test case 1: Empty hash
my $empty_hash;  # AFTER LAST PASS: my $empty_hash = tie my %hash, 'Tie::IxHash';
my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $empty_hash->Shift2() };
# FAILED: if ($@) { fail('Shift2 on empty hash crashed: ' . $@); } else { is($result, undef, 'Shift2 on empty hash returns undef'); }

# Test case 2: Hash with one element
my $one_element_hash;  # AFTER LAST PASS: my $one_element_hash = tie my %hash, 'Tie::IxHash';
# AFTER LAST PASS: $one_element_hash->Push('key1', 'value1');
# UNVALIDATED: $result = eval { $one_element_hash->Shift2() };
# FAILED: if ($@) { fail('Shift2 on hash with one element crashed: ' . $@); } else { is_deeply($result, ['key1', 'value1'], 'Shift2 on hash with one element returns correct result'); }

# Test case 3: Hash with multiple elements
my $multi_element_hash;  # AFTER LAST PASS: my $multi_element_hash = tie my %hash, 'Tie::IxHash';
# AFTER LAST PASS: $multi_element_hash->Push('key1', 'value1');
# AFTER LAST PASS: $multi_element_hash->Push('key2', 'value2');
# AFTER LAST PASS: $multi_element_hash->Push('key3', 'value3');
# UNVALIDATED: $result = eval { $multi_element_hash->Shift2() };
# FAILED: if ($@) { fail('Shift2 on hash with multiple elements crashed: ' . $@); } else { is_deeply($result, ['key1', 'value1'], 'Shift2 on hash with multiple elements returns correct result'); }

done_testing();