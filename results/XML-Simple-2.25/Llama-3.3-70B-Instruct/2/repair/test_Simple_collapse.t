use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::collapse"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'collapse is defined'); }

# Test case 1: Empty hash
my $result = eval { XML::Simple->new->collapse({}) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for empty hash'); }

# Test case 2: Hash with single key-value pair
my $hash = { key => 'value' };
$result = eval { XML::Simple->new->collapse($hash) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for hash with single key-value pair'); }

# Test case 3: Hash with multiple key-value pairs
$hash = { key1 => 'value1', key2 => 'value2' };
$result = eval { XML::Simple->new->collapse($hash) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for hash with multiple key-value pairs'); }

# Test case 4: Hash with nested elements
$hash = { key => { nested_key => 'nested_value' } };
$result = eval { XML::Simple->new->collapse($hash) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for hash with nested elements'); }

# Test case 5: Hash with array reference
$hash = { key => [ 'array_value1', 'array_value2' ] };
$result = eval { XML::Simple->new->collapse($hash) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for hash with array reference'); }

# Test case 6: Variable substitution
$hash = { key => '\{variable}' };
my $simple = XML::Simple->new;
$simple->{_var_values} = { variable => 'substituted_value' };
$result = eval { $simple->collapse($hash) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for variable substitution'); }

done_testing();
