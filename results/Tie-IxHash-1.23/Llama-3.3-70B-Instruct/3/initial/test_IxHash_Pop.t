use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::Pop"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'Pop is defined'); }

# Create a new Tie::IxHash object
my $ixhash = tie my %hash, 'Tie::IxHash';

# Test case 1: Empty hash
my $result = eval { $ixhash->Pop() };
if ($@) { fail('Pop crashed on empty hash: ' . $@); } else { is($result, undef, 'Pop returns undef on empty hash'); }

# Test case 2: Hash with one element
$ixhash->Push('key1', 'value1');
$result = eval { $ixhash->Pop() };
if ($@) { fail('Pop crashed on hash with one element: ' . $@); } else { is_deeply($result, ['key1', 'value1'], 'Pop returns correct key-value pair on hash with one element'); }

# Test case 3: Hash with multiple elements
$ixhash->Push('key2', 'value2');
$ixhash->Push('key3', 'value3');
$result = eval { $ixhash->Pop() };
if ($@) { fail('Pop crashed on hash with multiple elements: ' . $@); } else { is_deeply($result, ['key3', 'value3'], 'Pop returns correct key-value pair on hash with multiple elements'); }

# Test case 4: Multiple Pop operations
$result = eval { $ixhash->Pop() };
if ($@) { fail('Pop crashed on second Pop operation: ' . $@); } else { is_deeply($result, ['key2', 'value2'], 'Pop returns correct key-value pair on second Pop operation'); }
$result = eval { $ixhash->Pop() };
if ($@) { fail('Pop crashed on third Pop operation: ' . $@); } else { is_deeply($result, ['key1', 'value1'], 'Pop returns correct key-value pair on third Pop operation'); }
$result = eval { $ixhash->Pop() };
if ($@) { fail('Pop crashed on fourth Pop operation: ' . $@); } else { is($result, undef, 'Pop returns undef on fourth Pop operation'); }

done_testing();
