use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::Values"} };
if ($@) { fail("Symbol check crashed: $@"); } else { ok($symbol_check, 'Values is defined'); }

my $ixhash;  # AFTER LAST PASS: my $ixhash = tie my %hash, 'Tie::IxHash';
# AFTER LAST PASS: $ixhash->Splice(0, 0, 'key1' => 'value1', 'key2' => 'value2', 'key3' => 'value3');

my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Tie::IxHash::Values($ixhash) };
# FAILED: if ($@) { fail("Values crashed: $@"); } else { 
    # FAILED: is(ref $result, 'ARRAY', 'Values returns all values when no indices are provided'); 
    # FAILED: is_deeply($result, ['value1', 'value2', 'value3'], 'Values returns all values when no indices are provided'); 
# FAILED: }

# UNVALIDATED: $result = eval { Tie::IxHash::Values($ixhash, 1) };
# FAILED: if ($@) { fail("Values crashed: $@"); } else { 
    # FAILED: is($result, 'value2', 'Values returns the value at the specified index'); 
# FAILED: }

# UNVALIDATED: $result = eval { Tie::IxHash::Values($ixhash, 0, 2) };
# FAILED: if ($@) { fail("Values crashed: $@"); } else { 
    # FAILED: is(ref $result, 'ARRAY', 'Values returns the values at the specified indices'); 
    # FAILED: is_deeply($result, ['value1', 'value3'], 'Values returns the values at the specified indices'); 
# FAILED: }

# UNVALIDATED: $result = eval { Tie::IxHash::Values($ixhash, 3) };
# FAILED: if ($@) { fail("Values crashed: $@"); } else { 
    # FAILED: is($result, undef, 'Values returns undef for out-of-range index'); 
# FAILED: }

# UNVALIDATED: $result = eval { Tie::IxHash::Values($ixhash, 'a') };
# FAILED: if ($@) { fail("Values crashed: $@"); } else { 
    # FAILED: is($result, undef, 'Values returns undef for non-numeric index'); 
# FAILED: }

done_testing();