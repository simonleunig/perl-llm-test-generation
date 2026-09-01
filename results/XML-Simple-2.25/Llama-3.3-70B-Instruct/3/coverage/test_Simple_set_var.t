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
my $simple = bless({}, 'XML::Simple');
my $result = eval { $simple->set_var('test', 'value') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $simple->{_var_values}->{test}, 'set_var sets value'); }

# Test case 2: Edge case - uninitialized _var_values hash
my $simple2 = bless({}, 'XML::Simple');
my $result2 = eval { $simple2->set_var('test2', 'value2') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $simple2->{_var_values}->{test2}, 'set_var initializes _var_values hash'); }

# Test case 3: Error handling - invalid variable name
my $simple3 = bless({}, 'XML::Simple');
my $result3 = eval { $simple3->set_var('test3!', 'value3') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $simple3->{_var_values}->{'test3!'}, 'set_var handles invalid variable name'); }

done_testing();
