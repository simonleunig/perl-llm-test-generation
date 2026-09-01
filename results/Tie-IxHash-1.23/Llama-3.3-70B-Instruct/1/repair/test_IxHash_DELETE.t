use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::DELETE"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'DELETE is defined'); }

# Test case 1: Delete existing key
my $ixhash = tie my %hash, 'Tie::IxHash';
$hash{key1} = 'value1';
$hash{key2} = 'value2';
my $result = eval { Tie::IxHash::DELETE($ixhash, 'key1') };
if ($@) { fail('DELETE crashed: ' . $@); } else { is($result, 'value1', 'DELETE returns value for existing key'); }

# Test case 2: Delete non-existent key
$result = eval { Tie::IxHash::DELETE($ixhash, 'key3') };
if ($@) { fail('DELETE crashed: ' . $@); } else { is($result, undef, 'DELETE returns undef for non-existent key'); }

# Test case 3: Delete last key
$hash{key4} = 'value4';
$result = eval { Tie::IxHash::DELETE($ixhash, 'key4') };
if ($@) { fail('DELETE crashed: ' . $@); } else { is($result, 'value4', 'DELETE returns value for last key'); }

# Test case 4: Delete only key
%hash = ();
$hash{key5} = 'value5';
$result = eval { Tie::IxHash::DELETE($ixhash, 'key5') };
if ($@) { fail('DELETE crashed: ' . $@); } else { is($result, 'value5', 'DELETE returns value for only key'); }

done_testing();
