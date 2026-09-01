use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock;
use File::Temp;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::value_to_xml"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'value_to_xml is defined'); }

# Test case 1: Simple hashref
my $simple_hash = { foo => 'bar' };
my $result = eval { XML::Simple->new->value_to_xml($simple_hash) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for simple hashref'); }
is($result, '<foo>bar</foo>', 'Correct XML output for simple hashref');

# Test case 2: Hashref with nested elements
my $nested_hash = { foo => { bar => 'baz' } };
$result = eval { XML::Simple->new->value_to_xml($nested_hash) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for nested hashref'); }
is($result, '<foo><bar>baz</bar></foo>', 'Correct XML output for nested hashref');

# Test case 3: Arrayref
my $array_ref = [ 'foo', 'bar' ];
$result = eval { XML::Simple->new->value_to_xml($array_ref) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for arrayref'); }
is($result, '<anon>foo</anon><anon>bar</anon>', 'Correct XML output for arrayref');

# Test case 4: Circular data structure
my $circular_hash = { foo => {} };
$circular_hash->{foo} = $circular_hash;
$result = eval { XML::Simple->new->value_to_xml($circular_hash) };
if ($@) { like($@, qr/circular data structures not supported/, 'Correct error message for circular data structure'); } else { fail('Function did not crash for circular data structure'); }

# Test case 5: Undefined value
my $undefined_hash = { foo => undef };
$result = eval { XML::Simple->new->value_to_xml($undefined_hash) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for undefined value'); }
is($result, '<foo></foo>', 'Correct XML output for undefined value');

done_testing();
