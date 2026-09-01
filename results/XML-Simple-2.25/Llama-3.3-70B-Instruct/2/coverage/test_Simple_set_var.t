use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::set_var"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'set_var is defined'); }

# Test case 1: Normal operation with valid inputs
my $xml_simple = bless({}, 'XML::Simple');
my $result = eval { $xml_simple->set_var('test_var', 'test_value') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $xml_simple->{_var_values}, 'set_var sets _var_values'); }
is($xml_simple->{_var_values}->{test_var}, 'test_value', 'set_var sets correct value');

# Test case 2: Edge case with invalid variable name
$result = eval { $xml_simple->set_var('', 'test_value') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $xml_simple->{_var_values}, 'set_var sets _var_values with empty variable name'); }
is($xml_simple->{_var_values}->{''}, 'test_value', 'set_var sets correct value with empty variable name');

# Test case 3: Edge case with non-scalar value
$result = eval { $xml_simple->set_var('test_var', []) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $xml_simple->{_var_values}, 'set_var sets _var_values with non-scalar value'); }
is(ref($xml_simple->{_var_values}->{test_var}), 'ARRAY', 'set_var sets correct reference type with non-scalar value');

done_testing();
