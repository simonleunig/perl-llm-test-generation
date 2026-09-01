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
$hash{a} = 1;
$hash{b} = 2;
$hash{c} = 3;

# Test case: No indices provided
my $result = eval { Tie::IxHash::Values($ixhash) };
if ($@) { fail('Values crashed: ' . $@); } else { 
    is($result, [1, 2, 3], 'Values returns all values when no indices are provided'); 
}

# Test case: Single index provided
$result = eval { Tie::IxHash::Values($ixhash, 1) };
if ($@) { fail('Values crashed: ' . $@); } else { 
    is($result, 2, 'Values returns the value at the specified index'); 
}

# Test case: Multiple indices provided
$result = eval { Tie::IxHash::Values($ixhash, 0, 2) };
if ($@) { fail('Values crashed: ' . $@); } else { 
    is($result, [1, 3], 'Values returns the values at the specified indices'); 
}

# Test case: Out-of-range index
$result = eval { Tie::IxHash::Values($ixhash, 3) };
if ($@) { fail('Values crashed: ' . $@); } else { 
    is($result, undef, 'Values returns undef for out-of-range index'); 
}

done_testing();
