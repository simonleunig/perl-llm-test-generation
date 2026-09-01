use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::array_to_hash"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'array_to_hash is defined'); }

my $simple = bless {}, 'XML::Simple';

# Test case 1: keyattr is a hash
$simple->{opt} = { keyattr => { test => [ 'id', '-' ] } };
my $arrayref = [ { id => '1', name => 'Test 1' }, { id => '2', name => 'Test 2' } ];
my $result = eval { $simple->array_to_hash('test', $arrayref) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for hash keyattr'); }

# Test case 2: keyattr is an array
$simple->{opt} = { keyattr => [ 'id' ] };
$arrayref = [ { id => '1', name => 'Test 1' }, { id => '2', name => 'Test 2' } ];
$result = eval { $simple->array_to_hash('test', $arrayref) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for array keyattr'); }

# Test case 3: keyattr is not set
$simple->{opt} = {};
$arrayref = [ { id => '1', name => 'Test 1' }, { id => '2', name => 'Test 2' } ];
$result = eval { $simple->array_to_hash('test', $arrayref) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for unset keyattr'); }

# Test case 4: arrayref is empty
$simple->{opt} = { keyattr => { test => [ 'id', '-' ] } };
$arrayref = [];
$result = eval { $simple->array_to_hash('test', $arrayref) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for empty arrayref'); }

# Test case 5: element in arrayref does not contain key attribute
$simple->{opt} = { keyattr => { test => [ 'id', '-' ] } };
$arrayref = [ { name => 'Test 1' }, { id => '2', name => 'Test 2' } ];
$result = eval { $simple->array_to_hash('test', $arrayref) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for missing key attribute'); }

done_testing();