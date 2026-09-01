use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::Unshift"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'Unshift is defined'); }

# Test case 1: Adding new key-value pairs
my $tie = tie my %hash, 'Tie::IxHash';
my $result = eval { $tie->Unshift('key1', 'value1', 'key2', 'value2') };
if ($@) { fail('Unshift crashed: ' . $@); } else { ok(defined $result, 'Unshift returns result'); }
is($result, 2, 'Unshift returns correct count');

# Test case 2: Updating existing key-value pairs
$result = eval { $tie->Unshift('key1', 'new_value1', 'key3', 'value3') };
if ($@) { fail('Unshift crashed: ' . $@); } else { ok(defined $result, 'Unshift returns result'); }
is($result, 3, 'Unshift returns correct count');

# Test case 3: Adding duplicate keys
$result = eval { $tie->Unshift('key1', 'new_value1', 'key2', 'new_value2') };
if ($@) { fail('Unshift crashed: ' . $@); } else { ok(defined $result, 'Unshift returns result'); }
is($result, 3, 'Unshift returns correct count');

# Test case 4: Empty input
$result = eval { $tie->Unshift() };
if ($@) { fail('Unshift crashed: ' . $@); } else { ok(defined $result, 'Unshift returns result'); }
is($result, 3, 'Unshift returns correct count');

done_testing();
