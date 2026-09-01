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

# Test case 1: Normal operation
my $obj = bless {}, 'XML::Simple';
$obj->{_var_values} = {};
my $result = eval { $obj->set_var('test_var', 'test_value') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $obj->{_var_values}->{'test_var'}, 'set_var sets value'); }
is($obj->{_var_values}->{'test_var'}, 'test_value', 'set_var sets correct value');

# Test case 2: Edge case - _var_values not initialized
my $obj2 = bless {}, 'XML::Simple';
my $result2 = eval { $obj2->set_var('test_var', 'test_value') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $obj2->{_var_values}->{'test_var'}, 'set_var sets value even if _var_values is not initialized'); }
is($obj2->{_var_values}->{'test_var'}, 'test_value', 'set_var sets correct value even if _var_values is not initialized');

# Test case 3: Edge case - variable name is not a string
my $obj3 = bless {}, 'XML::Simple';
$obj3->{_var_values} = {};
my $result3 = eval { $obj3->set_var(123, 'test_value') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $obj3->{_var_values}->{'123'}, 'set_var sets value even if variable name is not a string'); }
is($obj3->{_var_values}->{'123'}, 'test_value', 'set_var sets correct value even if variable name is not a string');

done_testing();
