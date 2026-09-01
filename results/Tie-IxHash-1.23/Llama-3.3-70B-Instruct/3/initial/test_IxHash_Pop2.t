use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::Pop2"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'Pop2 is defined'); }

# Create a new Tie::IxHash object
my $ixhash = tie my %hash, 'Tie::IxHash';

# Test case: Pop2 from an empty hash
my $result = eval { $ixhash->Pop2() };
if ($@) { fail('Pop2 crashed: ' . $@); } else { is($result, undef, 'Pop2 from empty hash returns undef'); }

# Test case: Pop2 from a hash with one element
%hash = ();
$ixhash->Push('key1', 'value1');
$result = eval { $ixhash->Pop2() };
if ($@) { fail('Pop2 crashed: ' . $@); } else { is_deeply($result, ['key1', 'value1'], 'Pop2 from hash with one element returns correct key-value pair'); }

# Test case: Pop2 from a hash with multiple elements
%hash = ();
$ixhash->Push('key1', 'value1');
$ixhash->Push('key2', 'value2');
$ixhash->Push('key3', 'value3');
$result = eval { $ixhash->Pop2() };
if ($@) { fail('Pop2 crashed: ' . $@); } else { is_deeply($result, ['key3', 'value3'], 'Pop2 from hash with multiple elements returns correct key-value pair'); }

done_testing();
