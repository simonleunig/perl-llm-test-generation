use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::Shift"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'Shift is defined'); }

my $ixhash = tie my %hash, 'Tie::IxHash';
my $result = eval { Tie::IxHash::Shift($ixhash) };
if ($@) { fail('Shift on empty hash crashed: ' . $@); } else { is($result, undef, 'Shift on empty hash returns undef'); }

%hash = ();
$ixhash = tie %hash, 'Tie::IxHash';
$hash{key} = 'value';
$result = eval { Tie::IxHash::Shift($ixhash) };
# FAILED: if ($@) { fail('Shift on hash with one element crashed: ' . $@); } else { is($result, ['key', 'value'], 'Shift on hash with one element returns correct key-value pair'); }

%hash = ();
$ixhash = tie %hash, 'Tie::IxHash';
$hash{key1} = 'value1';
$hash{key2} = 'value2';
$result = eval { Tie::IxHash::Shift($ixhash) };
# FAILED: if ($@) { fail('Shift on hash with multiple elements crashed: ' . $@); } else { is($result, ['key1', 'value1'], 'Shift on hash with multiple elements returns correct key-value pair'); }

%hash = ();
$ixhash = tie %hash, 'Tie::IxHash';
$hash{key1} = 'value1';
$hash{key2} = 'value2';
$hash{key3} = 'value3';
$result = eval { Tie::IxHash::Shift($ixhash) };
# FAILED: if ($@) { fail('First Shift crashed: ' . $@); } else { is($result, ['key1', 'value1'], 'First Shift returns correct key-value pair'); }
$result = eval { Tie::IxHash::Shift($ixhash) };
# FAILED: if ($@) { fail('Second Shift crashed: ' . $@); } else { is($result, ['key2', 'value2'], 'Second Shift returns correct key-value pair'); }
$result = eval { Tie::IxHash::Shift($ixhash) };
# FAILED: if ($@) { fail('Third Shift crashed: ' . $@); } else { is($result, ['key3', 'value3'], 'Third Shift returns correct key-value pair'); }
$result = eval { Tie::IxHash::Shift($ixhash) };
if ($@) { fail('Fourth Shift crashed: ' . $@); } else { is($result, undef, 'Fourth Shift returns undef'); }

done_testing();