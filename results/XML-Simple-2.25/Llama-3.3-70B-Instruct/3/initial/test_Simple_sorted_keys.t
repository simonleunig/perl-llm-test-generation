use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::sorted_keys"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'sorted_keys is defined'); }

# Test case 1: nosort option is set
my $self = bless {}, 'XML::Simple';
$self->{opt} = { nosort => 1 };
my $ref = { key1 => 'value1', key2 => 'value2' };
my $result = eval { XML::Simple::sorted_keys($self, 'name', $ref) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result when nosort is set'); }
is_deeply($result, [ 'key1', 'key2' ], 'Keys are not sorted when nosort is set');

# Test case 2: KeyAttr option is set to a hash reference
$self->{opt} = { keyattr => { name => [ 'key1' ] } };
$ref = { key1 => 'value1', key2 => 'value2' };
$result = eval { XML::Simple::sorted_keys($self, 'name', $ref) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result when KeyAttr is a hash reference'); }
is_deeply($result, [ 'key1', 'key2' ], 'Key attribute is removed from the hash when KeyAttr is a hash reference');

# Test case 3: KeyAttr option is set to an array reference
$self->{opt} = { keyattr => [ 'key1' ] };
$ref = { key1 => 'value1', key2 => 'value2' };
$result = eval { XML::Simple::sorted_keys($self, 'name', $ref) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result when KeyAttr is an array reference'); }
is_deeply($result, [ 'key1', 'key2' ], 'Key attribute is removed from the hash when KeyAttr is an array reference');

# Test case 4: KeyAttr option is not set
$self->{opt} = {};
$ref = { key1 => 'value1', key2 => 'value2' };
$result = eval { XML::Simple::sorted_keys($self, 'name', $ref) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result when KeyAttr is not set'); }
is_deeply($result, [ 'key1', 'key2' ], 'Keys are sorted alphabetically when KeyAttr is not set');

done_testing();
