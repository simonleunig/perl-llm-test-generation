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
my $xml_simple = bless {}, 'XML::Simple';
$xml_simple->{_var_values} = { test => 'value' };
my $result = eval { $xml_simple->get_var('test') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'value', 'get_var returns value when variable exists'); }

# Test case 2: Variable does not exist
$result = eval { $xml_simple->get_var('nonexistent') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, '${nonexistent}', 'get_var returns ${name} when variable does not exist'); }

# Test case 3: Variable name is empty
$result = eval { $xml_simple->get_var('') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, '${}', 'get_var returns ${} when variable name is empty'); }

# Test case 4: Variable name is invalid (contains non-word characters)
$result = eval { $xml_simple->get_var('invalid@variable') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, '${invalid@variable}', 'get_var returns ${name} when variable name is invalid'); }

done_testing();
