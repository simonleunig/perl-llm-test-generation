use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }  # Use actual module name from package declaration

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::get_var"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'get_var is defined'); }

# Mocking the XML::Simple object
my $mock_xml_simple = mock('XML::Simple', override => [
    _var_values => {
        'var1' => 'value1',
        'var2' => 'value2',
    },
]);

# Test case: Variable exists in _var_values
my $result = eval { $mock_xml_simple->get_var('var1') };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, 'value1', 'get_var returns correct value when variable exists');
}

# Test case: Variable does not exist in _var_values
$result = eval { $mock_xml_simple->get_var('var3') };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, '${var3}', 'get_var returns ${name} when variable does not exist');
}

# Test case: Variable name is an empty string
$result = eval { $mock_xml_simple->get_var('') };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, '${}', 'get_var returns ${} when variable name is an empty string');
}

# Test case: Variable name contains invalid characters
$result = eval { $mock_xml_simple->get_var('var@name') };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, '${var@name}', 'get_var returns ${name} when variable name contains invalid characters');
}

# Test case: Variable name is undefined
$result = eval { $mock_xml_simple->get_var(undef) };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, '${}', 'get_var returns ${} when variable name is undefined');
}

# Clean up mock
$mock_xml_simple->unmock_all;

done_testing();
