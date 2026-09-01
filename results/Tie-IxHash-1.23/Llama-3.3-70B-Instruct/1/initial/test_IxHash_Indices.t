use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::Indices"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'Indices is defined'); }

# Create a tied hash object
my $tied_hash = tie my %hash, 'Tie::IxHash';

# Test case 1: Single key
my $result = eval { Tie::IxHash::Indices($tied_hash, 'key1') };
if ($@) { fail('Indices crashed with single key: ' . $@); } else { ok(defined $result, 'Indices returns result with single key'); }

# Test case 2: Multiple keys
$result = eval { Tie::IxHash::Indices($tied_hash, 'key1', 'key2') };
if ($@) { fail('Indices crashed with multiple keys: ' . $@); } else { ok(defined $result, 'Indices returns result with multiple keys'); }

# Test case 3: No keys
$result = eval { Tie::IxHash::Indices($tied_hash) };
if ($@) { fail('Indices crashed with no keys: ' . $@); } else { ok(defined $result, 'Indices returns result with no keys'); }

# Test case 4: Non-existent key
$result = eval { Tie::IxHash::Indices($tied_hash, 'non_existent_key') };
if ($@) { fail('Indices crashed with non-existent key: ' . $@); } else { ok(!defined $result, 'Indices returns undef with non-existent key'); }

done_testing();
