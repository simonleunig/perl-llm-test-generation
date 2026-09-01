use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::new"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'new is defined'); }

# Test case 1: Empty list
my $result = eval { Tie::IxHash->new() };
if ($@) { fail('new crashed with empty list: ' . $@); } else { ok(defined $result, 'new returns result with empty list'); }

# Test case 2: Single key-value pair
$result = eval { Tie::IxHash->new('key' => 'value') };
if ($@) { fail('new crashed with single key-value pair: ' . $@); } else { ok(defined $result, 'new returns result with single key-value pair'); }

# Test case 3: Multiple key-value pairs
$result = eval { Tie::IxHash->new('key1' => 'value1', 'key2' => 'value2') };
if ($@) { fail('new crashed with multiple key-value pairs: ' . $@); } else { ok(defined $result, 'new returns result with multiple key-value pairs'); }

# Test case 4: Duplicate keys
$result = eval { Tie::IxHash->new('key' => 'value1', 'key' => 'value2') };
if ($@) { fail('new crashed with duplicate keys: ' . $@); } else { ok(defined $result, 'new returns result with duplicate keys'); }

done_testing();
