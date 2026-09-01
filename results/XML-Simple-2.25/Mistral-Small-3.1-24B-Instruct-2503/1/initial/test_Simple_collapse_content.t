use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }  # Use actual module name from package declaration

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::collapse_content"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'collapse_content is defined'); }

# Mock the XML::Simple object
my $mock_self = mock('XML::Simple', override => [
    opt => { contentkey => 'content' }
]);

# Test case 1: Empty hash reference
my $empty_hash = {};
my $result = eval { XML::Simple::collapse_content($mock_self, $empty_hash) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, $empty_hash, 'Empty hash reference returns unchanged'); }

# Test case 2: Hash reference with no nested hashes
my $flat_hash = { key1 => 'value1', key2 => 'value2' };
$result = eval { XML::Simple::collapse_content($mock_self, $flat_hash) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, $flat_hash, 'Flat hash reference returns unchanged'); }

# Test case 3: Hash reference with nested hashes that do not contain the contentkey
my $nested_hash_no_contentkey = { key1 => { nested_key => 'value' }, key2 => { another_key => 'value' } };
$result = eval { XML::Simple::collapse_content($mock_self, $nested_hash_no_contentkey) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, $nested_hash_no_contentkey, 'Nested hashes without contentkey return unchanged'); }

# Test case 4: Hash reference with nested hashes that contain the contentkey
my $nested_hash_with_contentkey = { key1 => { content => 'value1' }, key2 => { content => 'value2' } };
my $expected_result = { key1 => 'value1', key2 => 'value2' };
$result = eval { XML::Simple::collapse_content($mock_self, $nested_hash_with_contentkey) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, $expected_result, 'Nested hashes with contentkey are collapsed correctly'); }

# Test case 5: Hash reference with nested hashes that contain more than one key-value pair
my $nested_hash_multiple_keys = { key1 => { content => 'value1', extra_key => 'extra_value' }, key2 => { content => 'value2' } };
$result = eval { XML::Simple::collapse_content($mock_self, $nested_hash_multiple_keys) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, $nested_hash_multiple_keys, 'Nested hashes with multiple keys return unchanged'); }

# Test case 6: Hash reference with mixed nested hashes
my $mixed_nested_hash = { key1 => { content => 'value1' }, key2 => { another_key => 'value2' }, key3 => { content => 'value3' } };
$result = eval { XML::Simple::collapse_content($mock_self, $mixed_nested_hash) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, { key1 => 'value1', key2 => { another_key => 'value2' }, key3 => 'value3' }, 'Mixed nested hashes are collapsed correctly'); }

done_testing();
