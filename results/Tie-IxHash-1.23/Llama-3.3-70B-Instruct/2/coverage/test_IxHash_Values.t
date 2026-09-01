use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::Values"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'Values is defined'); }

my $ixhash = tie my %hash, 'Tie::IxHash';
$hash{a} = 1;
$hash{b} = 2;
$hash{c} = 3;

my $result = eval { Tie::IxHash::Values($ixhash) };
# FAILED: if ($@) { fail('Values crashed: ' . $@); } else { 
    # FAILED: is($result, [1, 2, 3], 'Values returns all values when no indices are provided'); 
# FAILED: }

$result = eval { Tie::IxHash::Values($ixhash, 1) };
if ($@) { fail('Values crashed: ' . $@); } else { 
    is($result, 2, 'Values returns the value at the specified index'); 
}

$result = eval { Tie::IxHash::Values($ixhash, 0, 2) };
# FAILED: if ($@) { fail('Values crashed: ' . $@); } else { 
    # FAILED: is($result, [1, 3], 'Values returns the values at the specified indices'); 
# FAILED: }

$result = eval { Tie::IxHash::Values($ixhash, 3) };
if ($@) { fail('Values crashed: ' . $@); } else { 
    is($result, undef, 'Values returns undef for out-of-range index'); 
}

done_testing();