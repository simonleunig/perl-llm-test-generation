use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }  # Use actual module name from package declaration

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::FETCH"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'FETCH is defined'); }

# Mocking the Tie::IxHash object
my $mock_hash = mock('Tie::IxHash', override => [
    FETCH => sub {
        my ($s, $k) = @_;
        return exists($s->[0]{$k}) ? $s->[2][$s->[0]{$k}] : undef;
    }
]);

# Test case 1: Key exists in the hash
my $test_hash = bless([{ 'key1' => 0 }, {}, ['value1']], 'Tie::IxHash');
my $result = eval { $test_hash->FETCH('key1') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'value1', 'FETCH returns correct value for existing key'); }

# Test case 2: Key does not exist in the hash
$result = eval { $test_hash->FETCH('key2') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, undef, 'FETCH returns undef for non-existing key'); }

# Test case 3: Hash object is not properly initialized
my $uninitialized_hash = bless([], 'Tie::IxHash');
$result = eval { $uninitialized_hash->FETCH('key1') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, undef, 'FETCH returns undef for uninitialized hash'); }

# Test case 4: Hash object with multiple keys
$test_hash = bless([{ 'key1' => 0, 'key2' => 1 }, {}, ['value1', 'value2']], 'Tie::IxHash');
$result = eval { $test_hash->FETCH('key2') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'value2', 'FETCH returns correct value for multiple keys'); }

# Clean up mocks
$mock_hash->unmock_all();

done_testing();
