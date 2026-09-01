use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::Replace"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'Replace is defined'); }

# Create a Tie::IxHash object
my $tie_ix_hash = tie my %hash, 'Tie::IxHash';
$hash{key1} = 'value1';

# Test case 1: Replace with new key and value
my $result = eval { $tie_ix_hash->Replace(0, 'new_value', 'new_key') };
if ($@) { fail('Replace crashed: ' . $@); } else { is($result, 'new_key', 'Replace with new key and value'); }

# Test case 2: Replace with new value only
$result = eval { $tie_ix_hash->Replace(0, 'new_value') };
if ($@) { fail('Replace crashed: ' . $@); } else { is($result, 'new_key', 'Replace with new value only'); }

# Test case 3: Replace at invalid index
$result = eval { $tie_ix_hash->Replace(10, 'new_value', 'new_key') };
if ($@) { fail('Replace crashed: ' . $@); } else { is($result, undef, 'Replace at invalid index'); }

# Test case 4: Replace with undefined index
$result = eval { $tie_ix_hash->Replace(undef, 'new_value', 'new_key') };
if ($@) { fail('Replace crashed: ' . $@); } else { is($result, undef, 'Replace with undefined index'); }

done_testing();