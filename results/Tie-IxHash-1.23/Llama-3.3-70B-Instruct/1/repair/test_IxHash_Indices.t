use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::Indices"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'Indices is defined'); }

my $tied_hash = tie my %hash, 'Tie::IxHash';
$hash{'key1'} = 'value1';
$hash{'key2'} = 'value2';

my $result = eval { Tie::IxHash::Indices($tied_hash, 'key1') };
if ($@) { fail('Indices crashed with single key: ' . $@); } else { is($result, 'value1', 'Indices returns result with single key'); }

$result = eval { Tie::IxHash::Indices($tied_hash, 'key1', 'key2') };
if ($@) { fail('Indices crashed with multiple keys: ' . $@); } else { is_deeply($result, ['value1', 'value2'], 'Indices returns result with multiple keys'); }

$result = eval { Tie::IxHash::Indices($tied_hash) };
if ($@) { fail('Indices crashed with no keys: ' . $@); } else { ok(defined $result, 'Indices returns result with no keys'); }

$result = eval { Tie::IxHash::Indices($tied_hash, 'non_existent_key') };
if ($@) { fail('Indices crashed with non-existent key: ' . $@); } else { is($result, undef, 'Indices returns undef with non-existent key'); }

done_testing();