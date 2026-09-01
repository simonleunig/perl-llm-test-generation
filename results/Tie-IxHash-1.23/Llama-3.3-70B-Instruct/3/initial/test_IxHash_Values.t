use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::Values"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'Values is defined'); }

# Create a Tie::IxHash object
my $ixhash = tie my %hash, 'Tie::IxHash';
$ixhash->Splice(0, 0, 'key1' => 'value1', 'key2' => 'value2', 'key3' => 'value3');

# Test case 1: No indices provided
my $result = eval { Tie::IxHash::Values($ixhash) };
if ($@) { fail('Values crashed: ' . $@); } else { 
    is($result, ['value1', 'value2', 'value3'], 'Values returns all values when no indices are provided'); 
}

# Test case 2: Single index provided
$result = eval { Tie::IxHash::Values($ixhash, 1) };
if ($@) { fail('Values crashed: ' . $@); } else { 
    is($result, 'value2', 'Values returns the value at the specified index'); 
}

# Test case 3: Multiple indices provided
$result = eval { Tie::IxHash::Values($ixhash, 0, 2) };
if ($@) { fail('Values crashed: ' . $@); } else { 
    is($result, ['value1', 'value3'], 'Values returns the values at the specified indices'); 
}

# Test case 4: Out-of-range index
$result = eval { Tie::IxHash::Values($ixhash, 3) };
if ($@) { fail('Values crashed: ' . $@); } else { 
    is($result, undef, 'Values returns undef for out-of-range index'); 
}

# Test case 5: Invalid input (non-numeric index)
$result = eval { Tie::IxHash::Values($ixhash, 'a') };
if ($@) { fail('Values crashed: ' . $@); } else { 
    is($result, undef, 'Values returns undef for non-numeric index'); 
}

done_testing();
