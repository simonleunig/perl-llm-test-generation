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

# Test case 1: Create a new Tie::IxHash object with no arguments
my $result = eval { Tie::IxHash->new() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'new returns result with no arguments'); }

# Test case 2: Create a new Tie::IxHash object with key-value pairs
$result = eval { Tie::IxHash->new(a => 1, b => 2) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'new returns result with key-value pairs'); }

# Test case 3: Create a new Tie::IxHash object with duplicate keys
$result = eval { Tie::IxHash->new(a => 1, a => 2) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'new returns result with duplicate keys'); }

# Test case 4: Create a new Tie::IxHash object with an empty list
$result = eval { Tie::IxHash->new() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'new returns result with an empty list'); }

done_testing();
