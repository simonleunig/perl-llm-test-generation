use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::Replace"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'Replace is defined'); }

my $ixhash = tie my %hash, 'Tie::IxHash';

my $result = eval { $ixhash->Replace(0, 'new_value', 'new_key') };
if ($@) { fail('Replace crashed: ' . $@); } else { is($result, 'new_key', 'Replace with new key and value'); }

$result = eval { $ixhash->Replace(0, 'new_value') };
if ($@) { fail('Replace crashed: ' . $@); } else { is($result, 'new_key', 'Replace with new value only'); }

$result = eval { $ixhash->Replace(10, 'new_value', 'new_key') };
if ($@) { fail('Replace crashed: ' . $@); } else { is($result, undef, 'Replace with out of range index'); }

$result = eval { $ixhash->Replace(undef, 'new_value', 'new_key') };
if ($@) { fail('Replace crashed: ' . $@); } else { is($result, undef, 'Replace with undefined index'); }

$ixhash->Replace(0, 'existing_value', 'existing_key');
$result = eval { $ixhash->Replace(0, 'new_value', 'existing_key') };
if ($@) { fail('Replace crashed: ' . $@); } else { is($result, 'existing_key', 'Replace with existing key'); }

done_testing();