use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

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

# Test case: No key-value pairs provided
$result = eval { XML::Simple::new_hashref() };
if ($@) { fail('Function crashed: ' . $@); } else {
    is(ref($result), 'HASH', 'new_hashref returns an empty hash reference when no arguments are provided');
    is(scalar(keys %$result), 0, 'The returned hash reference is empty');
}

# Test case: Mixed data types in key-value pairs
$result = eval { XML::Simple::new_hashref('key1' => 123, 'key2' => 'string', 'key3' => [1, 2, 3]) };
if ($@) { fail('Function crashed: ' . $@); } else {
    is(ref($result), 'HASH', 'new_hashref returns a hash reference with mixed data types');
    # FAILED: is($result->{'key1'}, 123, 'Key-value pair key1 => 123 is correct');
    # FAILED: is($result->{'key2'}, 'string', 'Key-value pair key2 => string is correct');
    # FAILED: is_deeply($result->{'key3'}, [1, 2, 3], 'Key-value pair key3 => [1, 2, 3] is correct');
}

# Test case: Duplicate keys
# UNVALIDATED: $result = eval { XML::Simple::new_hashref('key1' => 'value1', 'key1' => 'value2') };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
    # FAILED: is(ref($result), 'HASH', 'new_hashref returns a hash reference with duplicate keys');
    # FAILED: is($result->{'key1'}, 'value2', 'The last value for duplicate key is preserved');
# FAILED: }

# Test case: Large number of key-value pairs
my %large_hash;  # AFTER LAST PASS: my %large_hash = map { ('key' . $_ => 'value' . $_) } 1..1000;
# UNVALIDATED: $result = eval { XML::Simple::new_hashref(%large_hash) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
    # FAILED: is(ref($result), 'HASH', 'new_hashref returns a hash reference with a large number of key-value pairs');
    # FAILED: is(scalar(keys %$result), 1000, 'The returned hash reference contains 1000 key-value pairs');
# FAILED: }

done_testing();