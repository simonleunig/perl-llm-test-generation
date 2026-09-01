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
if ($@) { fail('Pop on empty hash crashed: ' . $@); } else { is($result, undef, 'Pop on empty hash returns undef'); }

# Test case 2: Hash with one element
$ixhash->Push('key1', 'value1');
$result = eval { $ixhash->Pop() };
if ($@) { fail('Pop on hash with one element crashed: ' . $@); } else { is_deeply($result, ['key1', 'value1'], 'Pop on hash with one element returns correct key-value pair'); }

# Test case 3: Hash with multiple elements
$ixhash->Push('key2', 'value2');
$ixhash->Push('key3', 'value3');
$result = eval { $ixhash->Pop() };
if ($@) { fail('Pop on hash with multiple elements crashed: ' . $@); } else { is_deeply($result, ['key3', 'value3'], 'Pop on hash with multiple elements returns correct key-value pair'); }

# Test case 4: Pop multiple times
$result = eval { $ixhash->Pop() };
if ($@) { fail('Second Pop crashed: ' . $@); } else { is_deeply($result, ['key2', 'value2'], 'Second Pop returns correct key-value pair'); }
$result = eval { $ixhash->Pop() };
if ($@) { fail('Third Pop crashed: ' . $@); } else { is_deeply($result, ['key1', 'value1'], 'Third Pop returns correct key-value pair'); }
$result = eval { $ixhash->Pop() };
if ($@) { fail('Fourth Pop crashed: ' . $@); } else { is($result, undef, 'Fourth Pop returns undef'); }

done_testing();
