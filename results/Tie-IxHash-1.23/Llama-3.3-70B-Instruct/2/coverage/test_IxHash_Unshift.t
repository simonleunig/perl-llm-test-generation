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

# Test case 1: Adding new key-value pairs to an empty hash
my $tie = tie my %hash, 'Tie::IxHash';
my $result = eval { $tie->Unshift('key1', 'value1', 'key2', 'value2') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 2, 'Added 2 key-value pairs to an empty hash'); }

# Test case 2: Adding new key-value pairs to a non-empty hash
%hash = ();
$tie = tie %hash, 'Tie::IxHash';
$tie->Unshift('key1', 'value1');
$result = eval { $tie->Unshift('key2', 'value2', 'key3', 'value3') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 3, 'Added 2 key-value pairs to a non-empty hash'); }

# Test case 3: Updating existing key-value pairs
%hash = ();
$tie = tie %hash, 'Tie::IxHash';
$tie->Unshift('key1', 'value1');
$result = eval { $tie->Unshift('key1', 'new_value') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 1, 'Updated an existing key-value pair'); }

# Test case 4: Adding duplicate key-value pairs
%hash = ();
$tie = tie %hash, 'Tie::IxHash';
$tie->Unshift('key1', 'value1');
$result = eval { $tie->Unshift('key1', 'value1') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 1, 'Added a duplicate key-value pair'); }

done_testing();
