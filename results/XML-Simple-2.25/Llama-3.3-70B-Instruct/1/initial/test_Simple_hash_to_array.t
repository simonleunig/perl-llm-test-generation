use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::hash_to_array"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'hash_to_array is defined'); }

# Test case 1: Normal operation with nosort option disabled
my $xml_simple = bless({}, 'XML::Simple');
$xml_simple->{opt} = { nosort => 0, keyattr => [ 'attr' ] };
my $hashref = { key1 => { attr => 'value1' }, key2 => { attr => 'value2' } };
my $result = eval { $xml_simple->hash_to_array(undef, $hashref) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }
is(ref($result), 'ARRAY', 'Result is an array reference');
is(scalar @$result, 2, 'Result array has 2 elements');

# Test case 2: Normal operation with nosort option enabled
$xml_simple->{opt} = { nosort => 1, keyattr => [ 'attr' ] };
$result = eval { $xml_simple->hash_to_array(undef, $hashref) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }
is(ref($result), 'ARRAY', 'Result is an array reference');
is(scalar @$result, 2, 'Result array has 2 elements');

# Test case 3: Edge case with keyattr option not defined
$xml_simple->{opt} = { nosort => 0 };
$result = eval { $xml_simple->hash_to_array(undef, $hashref) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }
is(ref($result), 'HASH', 'Result is a hash reference');

# Test case 4: Edge case with input hash containing non-hash values
$hashref = { key1 => 'value1', key2 => { attr => 'value2' } };
$result = eval { $xml_simple->hash_to_array(undef, $hashref) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }
is(ref($result), 'HASH', 'Result is a hash reference');

done_testing();
