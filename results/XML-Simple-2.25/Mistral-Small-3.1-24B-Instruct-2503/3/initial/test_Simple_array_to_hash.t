use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }  # Use actual module name from package declaration

# Mock dependencies
mock 'XML::Simple' => (
    new_hashref => sub { return {} },
    die_or_warn => sub { die shift },
    normalise_space => sub { return shift },
    collapse_content => sub { return shift },
);

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::array_to_hash"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'array_to_hash is defined'); }

# Test case: Empty array
my $self = bless({}, 'XML::Simple');
my $name = 'test';
my $arrayref = [];
my $result = eval { XML::Simple::array_to_hash($self, $name, $arrayref) };
is($@, '', 'No error for empty array');
is_deeply($result, {}, 'Returns empty hash for empty array');

# Test case: Array with non-hash elements
$arrayref = [1, 2, 3];
$result = eval { XML::Simple::array_to_hash($self, $name, $arrayref) };
is($@, '', 'No error for array with non-hash elements');
is_deeply($result, $arrayref, 'Returns original array for non-hash elements');

# Test case: Array with hashes missing key attribute
$arrayref = [{ key => 'value1' }, { key => 'value2' }];
$self->{opt} = { keyattr => { test => ['key', '-'] } };
$result = eval { XML::Simple::array_to_hash($self, $name, $arrayref) };
is($@, '', 'No error for missing key attribute');
is_deeply($result, $arrayref, 'Returns original array for missing key attribute');

# Test case: Array with non-scalar key attribute
$arrayref = [{ key => 'value1' }, { key => ['not_scalar'] }];
$result = eval { XML::Simple::array_to_hash($self, $name, $arrayref) };
like($@, qr/non-scalar/, 'Error for non-scalar key attribute');
is_deeply($result, $arrayref, 'Returns original array for non-scalar key attribute');

# Test case: Array with non-unique key attribute values
$arrayref = [{ key => 'value1' }, { key => 'value1' }];
$result = eval { XML::Simple::array_to_hash($self, $name, $arrayref) };
like($@, qr/non-unique/, 'Error for non-unique key attribute values');
is_deeply($result, $arrayref, 'Returns original array for non-unique key attribute values');

# Test case: Normal operation with unique key attribute values
$arrayref = [{ key => 'value1' }, { key => 'value2' }];
$self->{opt} = { keyattr => ['key'], normalisespace => 1, collapseagain => 1 };
$result = eval { XML::Simple::array_to_hash($self, $name, $arrayref) };
is($@, '', 'No error for normal operation');
is_deeply($result, { value1 => { key => 'value1' }, value2 => { key => 'value2' } }, 'Correct hash transformation');

# Test case: Normal operation with keyattr as hash
$arrayref = [{ key => 'value1' }, { key => 'value2' }];
$self->{opt} = { keyattr => { test => ['key', '-'] }, normalisespace => 1, collapseagain => 1 };
$result = eval { XML::Simple::array_to_hash($self, $name, $arrayref) };
is($@, '', 'No error for keyattr as hash');
is_deeply($result, { value1 => { '-key' => 'value1' }, value2 => { '-key' => 'value2' } }, 'Correct hash transformation with keyattr as hash');

done_testing();
