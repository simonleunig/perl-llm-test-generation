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
my $self = bless { opt => { nosort => 1 } }, 'XML::Simple';
my $ref = { a => 1, b => 2, c => 3 };
my $name = 'test';
my $result = eval { XML::Simple::sorted_keys($self, $name, $ref) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }
is_deeply($result, [qw(a b c)], 'nosort option works correctly');

# Test case 2: KeyAttr option is set to a hash reference
$self = bless { opt => { keyattr => { test => ['a'] } } }, 'XML::Simple';
$ref = { a => 1, b => 2, c => 3 };
$name = 'test';
$result = eval { XML::Simple::sorted_keys($self, $name, $ref) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }
is_deeply($result, [qw(a b c)], 'KeyAttr option works correctly with hash reference');

# Test case 3: KeyAttr option is set to an array reference
$self = bless { opt => { keyattr => ['a'] } }, 'XML::Simple';
$ref = { a => 1, b => 2, c => 3 };
$name = 'test';
$result = eval { XML::Simple::sorted_keys($self, $name, $ref) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }
is_deeply($result, [qw(a b c)], 'KeyAttr option works correctly with array reference');

# Test case 4: KeyAttr option is not set
$self = bless { opt => {} }, 'XML::Simple';
$ref = { a => 1, b => 2, c => 3 };
$name = 'test';
$result = eval { XML::Simple::sorted_keys($self, $name, $ref) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }
is_deeply($result, [qw(a b c)], 'Function works correctly without KeyAttr option');

done_testing();
