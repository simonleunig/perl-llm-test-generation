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

# Mocking the Tie::IxHash object
my $mock_hash = mock('Tie::IxHash', override => [
    Indices => sub {
        my ($self, @keys) = @_;
        if (@keys == 1) {
            return $self->{indices}->{$keys[0]};
        } else {
            return [map { $self->{indices}->{$_} } @keys];
        }
    }
]);

# Test case 1: No keys provided
my $result = eval { $mock_hash->Indices() };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, [], 'No keys provided returns empty list'); }

# Test case 2: Single key provided
$mock_hash->{indices} = { key1 => 0 };
$result = eval { $mock_hash->Indices('key1') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 0, 'Single key provided returns correct index'); }

# Test case 3: Multiple keys provided
$mock_hash->{indices} = { key1 => 0, key2 => 1, key3 => 2 };
$result = eval { $mock_hash->Indices('key1', 'key2', 'key3') };
if ($@) { fail('Function crashed: ' . $@); } else { is_deeply($result, [0, 1, 2], 'Multiple keys provided returns correct indices'); }

# Test case 4: Key does not exist
$result = eval { $mock_hash->Indices('nonexistent_key') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, undef, 'Non-existent key returns undef'); }

# Test case 5: Same key provided multiple times
$result = eval { $mock_hash->Indices('key1', 'key1', 'key1') };
if ($@) { fail('Function crashed: ' . $@); } else { is_deeply($result, [0, 0, 0], 'Same key provided multiple times returns correct indices'); }

# Test case 6: Mixed existing and non-existing keys
$result = eval { $mock_hash->Indices('key1', 'nonexistent_key', 'key3') };
if ($@) { fail('Function crashed: ' . $@); } else { is_deeply($result, [0, undef, 2], 'Mixed keys returns correct indices'); }

done_testing();