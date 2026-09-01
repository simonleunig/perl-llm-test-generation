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

# Create a mock object for XML::Simple
my $mock_object = bless {}, 'XML::Simple';

# Test case 1: Variable is defined
$mock_object->{_var_values} = { test_var => 'test_value' };
my $result = eval { $mock_object->get_var('test_var') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'test_value', 'get_var returns defined variable value'); }

# Test case 2: Variable is not defined
$mock_object->{_var_values} = {};
$result = eval { $mock_object->get_var('test_var') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, '${test_var}', 'get_var returns undefined variable in ${} format'); }

# Test case 3: Variable name is empty
$result = eval { $mock_object->get_var('') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, '${}', 'get_var returns empty variable in ${} format'); }

# Test case 4: Variable name is invalid (contains special characters)
$result = eval { $mock_object->get_var('test_var!') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, '${test_var!}', 'get_var returns invalid variable in ${} format'); }

done_testing();
