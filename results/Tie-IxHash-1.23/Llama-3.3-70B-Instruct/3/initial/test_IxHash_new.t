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

# Test case: Create a new Tie::IxHash object with key-value pairs
my $result = eval { Tie::IxHash->new('key1' => 'value1', 'key2' => 'value2') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'new returns result'); }

# Test case: Create a new Tie::IxHash object with an empty list
$result = eval { Tie::IxHash->new() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'new returns result with empty list'); }

# Test case: Create a new Tie::IxHash object with duplicate keys
$result = eval { Tie::IxHash->new('key1' => 'value1', 'key1' => 'value2') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'new returns result with duplicate keys'); }

done_testing();
