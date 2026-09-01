use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::Push"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'Push is defined'); }

# Create a new Tie::IxHash object
my $ixhash = tie my %hash, 'Tie::IxHash';

# Test case 1: Push with key-value pairs
my $result = eval { Tie::IxHash::Push($ixhash, 'key1', 'value1', 'key2', 'value2') };
if ($@) { fail('Push crashed: ' . $@); } else { ok(defined $result, 'Push returns result'); }
is($result, 2, 'Push returns correct count');

# Test case 2: Push with empty list
$result = eval { Tie::IxHash::Push($ixhash) };
if ($@) { fail('Push crashed: ' . $@); } else { ok(defined $result, 'Push returns result'); }
is($result, 2, 'Push returns correct count with empty list');

# Test case 3: Push with duplicate key
$result = eval { Tie::IxHash::Push($ixhash, 'key1', 'new_value') };
if ($@) { fail('Push crashed: ' . $@); } else { ok(defined $result, 'Push returns result'); }
is($result, 2, 'Push returns correct count with duplicate key');

# Test case 4: Push with invalid arguments
$result = eval { Tie::IxHash::Push($ixhash, 'key', 'value', 'extra_arg') };
if ($@) { fail('Push crashed: ' . $@); } else { ok(defined $result, 'Push returns result'); }
is($result, 3, 'Push returns correct count with invalid arguments');

done_testing();
