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

# Create a new Tie::IxHash object
my $ixhash = tie my %hash, 'Tie::IxHash';
$hash{key} = 'value';

# Test case 1: Replace with new key and value
my $result = eval { $ixhash->Replace(0, 'new_value', 'new_key') };
if ($@) { fail('Replace crashed: ' . $@); } else { ok(defined $result, 'Replace returns result'); }
is($result, 'new_key', 'Replace with new key and value');

# Test case 2: Replace with new value only
$result = eval { $ixhash->Replace(0, 'new_value') };
if ($@) { fail('Replace crashed: ' . $@); } else { ok(defined $result, 'Replace returns result'); }
is($result, 'new_key', 'Replace with new value only');

# Test case 3: Replace with out of range index
$result = eval { $ixhash->Replace(10, 'new_value', 'new_key') };
if ($@) { fail('Replace crashed: ' . $@); } else { ok(!defined $result, 'Replace returns undef for out of range index'); }
is($result, undef, 'Replace with out of range index');

# Test case 4: Replace with undefined index
$result = eval { $ixhash->Replace(undef, 'new_value', 'new_key') };
if ($@) { fail('Replace crashed: ' . $@); } else { ok(!defined $result, 'Replace returns undef for undefined index'); }
is($result, undef, 'Replace with undefined index');

done_testing();