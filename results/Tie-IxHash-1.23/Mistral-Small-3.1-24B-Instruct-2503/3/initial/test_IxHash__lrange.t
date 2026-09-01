use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }  # Use actual module name from package declaration

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::_lrange"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, '_lrange is defined'); }

# Mock the Tie::IxHash object
my $mock_hash = mock('Tie::IxHash', override => [
    [ qr/^new$/ => sub { bless [ [], [] ], 'Tie::IxHash' } ],
]);

# Test case 1: Offset is undefined
my $result = eval { Tie::IxHash::_lrange($mock_hash, undef) };
is($@, '', 'No exception thrown when offset is undefined');
is($result, undef, 'Returns undef when offset is undefined');

# Test case 2: Offset is negative and within bounds
$mock_hash->[1] = [1, 2, 3, 4, 5];
$result = eval { Tie::IxHash::_lrange($mock_hash, -2) };
is($@, '', 'No exception thrown when offset is negative and within bounds');
is($result, [3, 4, 2], 'Correct range when offset is negative and within bounds');

# Test case 3: Offset is negative and out of bounds
$result = eval { Tie::IxHash::_lrange($mock_hash, -10) };
is($@, '', 'No exception thrown when offset is negative and out of bounds');
is($result, [0, 0, 1], 'Correct range when offset is negative and out of bounds');

# Test case 4: Offset is positive and within bounds
$result = eval { Tie::IxHash::_lrange($mock_hash, 2) };
is($@, '', 'No exception thrown when offset is positive and within bounds');
is($result, [2, 4, 3], 'Correct range when offset is positive and within bounds');

# Test case 5: Offset is positive and out of bounds
$result = eval { Tie::IxHash::_lrange($mock_hash, 10) };
is($@, '', 'No exception thrown when offset is positive and out of bounds');
is($result, [5, 5, 1], 'Correct range when offset is positive and out of bounds');

# Test case 6: Length is negative
$result = eval { Tie::IxHash::_lrange($mock_hash, 2, -2) };
is($@, '', 'No exception thrown when length is negative');
is($result, [2, 3, 2], 'Correct range when length is negative');

# Test case 7: Length is greater than remaining elements
$result = eval { Tie::IxHash::_lrange($mock_hash, 2, 10) };
is($@, '', 'No exception thrown when length is greater than remaining elements');
is($result, [2, 4, 3], 'Correct range when length is greater than remaining elements');

# Test case 8: Length is zero
$result = eval { Tie::IxHash::_lrange($mock_hash, 2, 0) };
is($@, '', 'No exception thrown when length is zero');
is($result, [2, 1, 0], 'Correct range when length is zero');

# Test case 9: Length is undefined
$result = eval { Tie::IxHash::_lrange($mock_hash, 2) };
is($@, '', 'No exception thrown when length is undefined');
is($result, [2, 4, 3], 'Correct range when length is undefined');

done_testing();
