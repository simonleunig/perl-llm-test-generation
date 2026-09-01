use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::get_var"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'get_var is defined'); }

# Test case 1: Variable exists
my $xml_simple = bless { _var_values => { test => 'value' } }, 'XML::Simple';
my $result = eval { $xml_simple->get_var('test') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'value', 'get_var returns existing variable value'); }

# Test case 2: Variable does not exist
$result = eval { $xml_simple->get_var('nonexistent') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, '${nonexistent}', 'get_var returns ${name} for nonexistent variable'); }

# Test case 3: Variable name with word characters and dots
$xml_simple = bless { _var_values => { 'test.variable' => 'value' } }, 'XML::Simple';
$result = eval { $xml_simple->get_var('test.variable') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'value', 'get_var returns existing variable value with word characters and dots'); }

# Test case 4: Variable name with invalid characters
$xml_simple = bless { _var_values => {} }, 'XML::Simple';
$result = eval { $xml_simple->get_var('test-variable') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, '${test-variable}', 'get_var returns ${name} for variable with invalid characters'); }

done_testing();
