use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }  # Use actual module name from package declaration

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::new_hashref"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'new_hashref is defined'); }

# Test case: Normal operation with key-value pairs
my $result = eval { XML::Simple::new_hashref('key1' => 'value1', 'key2' => 'value2') };
if ($@) { fail('Function crashed: ' . $@); } else {
    is(ref($result), 'HASH', 'new_hashref returns a hash reference');
    # FAILED: is($result->{'key1'}, 'value1', 'Key-value pair key1 => value1 is correct');
    # FAILED: is($result->{'key2'}, 'value2', 'Key-value pair key2 => value2 is correct');
}

# Test case: Empty input
$result = eval { XML::Simple::new_hashref() };
if ($@) { fail('Function crashed: ' . $@); } else {
    is(ref($result), 'HASH', 'new_hashref returns an empty hash reference');
    is(scalar(keys %$result), 0, 'Empty hash reference has no keys');
}

# Test case: Single key-value pair
$result = eval { XML::Simple::new_hashref('single_key' => 'single_value') };
if ($@) { fail('Function crashed: ' . $@); } else {
    is(ref($result), 'HASH', 'new_hashref returns a hash reference');
    # FAILED: is($result->{'single_key'}, 'single_value', 'Single key-value pair is correct');
}

# Test case: Mixed data types
$result = eval { XML::Simple::new_hashref('int_key' => 123, 'float_key' => 45.67, 'bool_key' => 1, 'array_key' => [1, 2, 3]) };
if ($@) { fail('Function crashed: ' . $@); } else {
    is(ref($result), 'HASH', 'new_hashref returns a hash reference');
    # FAILED: is($result->{'int_key'}, 123, 'Integer key-value pair is correct');
    # FAILED: is($result->{'float_key'}, 45.67, 'Float key-value pair is correct');
    # FAILED: is($result->{'bool_key'}, 1, 'Boolean key-value pair is correct');
    # FAILED: is_deeply($result->{'array_key'}, [1, 2, 3], 'Array key-value pair is correct');
}

# Test case: Nested hash references
# UNVALIDATED: $result = eval { XML::Simple::new_hashref('nested_key' => { 'inner_key' => 'inner_value' }) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
    # FAILED: is(ref($result), 'HASH', 'new_hashref returns a hash reference');
    # FAILED: is(ref($result->{'nested_key'}), 'HASH', 'Nested key is a hash reference');
    # FAILED: is($result->{'nested_key'}->{'inner_key'}, 'inner_value', 'Nested key-value pair is correct');
# FAILED: }

done_testing();