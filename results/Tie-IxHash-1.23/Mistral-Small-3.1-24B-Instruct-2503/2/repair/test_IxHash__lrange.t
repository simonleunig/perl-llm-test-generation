use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::_lrange"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, '_lrange is defined'); }

my $mock_hash = bless([undef, [qw(a b c d e)]], 'Tie::IxHash');

my $result = eval { Tie::IxHash::_lrange($mock_hash, undef) };
is($@, '', 'No exception thrown when offset is undefined');
is($result, undef, 'Returns undef when offset is undefined');

$result = eval { Tie::IxHash::_lrange($mock_hash, -2) };
is($@, '', 'No exception thrown when offset is negative');
is($result, [2, 4, 3], 'Correct range when offset is negative');

$result = eval { Tie::IxHash::_lrange($mock_hash, 10) };
is($@, '', 'No exception thrown when offset is greater than the size of the hash');
is($result, [5, 4, 0], 'Correct range when offset is greater than the size of the hash');

$result = eval { Tie::IxHash::_lrange($mock_hash, 2, -2) };
is($@, '', 'No exception thrown when length is negative');
is($result, [2, 3, 2], 'Correct range when length is negative');

$result = eval { Tie::IxHash::_lrange($mock_hash, 2, 10) };
is($@, '', 'No exception thrown when length is greater than the remaining elements');
is($result, [2, 4, 3], 'Correct range when length is greater than the remaining elements');

$result = eval { Tie::IxHash::_lrange($mock_hash, 1, 3) };
is($@, '', 'No exception thrown for normal case');
is($result, [1, 3, 3], 'Correct range for normal case');

$result = eval { Tie::IxHash::_lrange($mock_hash, 0, 0) };
is($@, '', 'No exception thrown when offset is zero and length is zero');
is($result, [0, -1, 0], 'Correct range when offset is zero and length is zero');

$result = eval { Tie::IxHash::_lrange($mock_hash, 0) };
is($@, '', 'No exception thrown when offset is zero and length is undefined');
is($result, [0, 4, 5], 'Correct range when offset is zero and length is undefined');

$result = eval { Tie::IxHash::_lrange($mock_hash, 5) };
is($@, '', 'No exception thrown when offset is the size of the hash and length is undefined');
is($result, [5, 4, 0], 'Correct range when offset is the size of the hash and length is undefined');

$result = eval { Tie::IxHash::_lrange($mock_hash, 5, 0) };
is($@, '', 'No exception thrown when offset is the size of the hash and length is zero');
is($result, [5, 4, 0], 'Correct range when offset is the size of the hash and length is zero');

done_testing();