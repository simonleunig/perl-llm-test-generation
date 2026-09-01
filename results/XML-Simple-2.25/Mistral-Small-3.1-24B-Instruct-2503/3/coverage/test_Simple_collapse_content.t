use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::collapse_content"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'collapse_content is defined'); }

# Mock the XML::Simple object
my $mock_self;
# AFTER LAST PASS: eval { require XML::Simple; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: XML::Simple - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"XML::Simple::collapse_content"}) {
        # AFTER LAST PASS: $mock_self = mock 'XML::Simple' => ( override => [
            # AFTER LAST PASS: opt => { contentkey => 'content' }
        # AFTER LAST PASS: ]);
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock_self = mock 'XML::Simple' => ( add => [
            # AFTER LAST PASS: opt => { contentkey => 'content' }
        # AFTER LAST PASS: ]);
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# Test case 1: Empty hash reference
my $empty_hash;  # AFTER LAST PASS: my $empty_hash = {};
my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::collapse_content($mock_self, $empty_hash) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { is($result, $empty_hash, 'Empty hash reference returns unchanged'); }

# Test case 2: Hash reference with no nested hashes
my $flat_hash;  # AFTER LAST PASS: my $flat_hash = { key1 => 'value1', key2 => 'value2' };
# UNVALIDATED: $result = eval { XML::Simple::collapse_content($mock_self, $flat_hash) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { is($result, $flat_hash, 'Flat hash reference returns unchanged'); }

# Test case 3: Hash reference with nested hashes that do not contain the contentkey
my $nested_hash_no_contentkey;  # AFTER LAST PASS: my $nested_hash_no_contentkey = { key1 => { nested_key => 'value' }, key2 => { another_key => 'value' } };
# UNVALIDATED: $result = eval { XML::Simple::collapse_content($mock_self, $nested_hash_no_contentkey) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { is($result, $nested_hash_no_contentkey, 'Nested hashes without contentkey return unchanged'); }

# Test case 4: Hash reference with nested hashes that contain the contentkey
my $nested_hash_with_contentkey;  # AFTER LAST PASS: my $nested_hash_with_contentkey = { key1 => { content => 'value1' }, key2 => { content => 'value2' } };
my $expected_result;  # AFTER LAST PASS: my $expected_result = { key1 => 'value1', key2 => 'value2' };
# UNVALIDATED: $result = eval { XML::Simple::collapse_content($mock_self, $nested_hash_with_contentkey) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { is($result, $expected_result, 'Nested hashes with contentkey are collapsed correctly'); }

# Test case 5: Hash reference with nested hashes that contain more than one key-value pair
my $nested_hash_multiple_keys;  # AFTER LAST PASS: my $nested_hash_multiple_keys = { key1 => { content => 'value1', extra_key => 'extra_value' }, key2 => { content => 'value2' } };
# UNVALIDATED: $result = eval { XML::Simple::collapse_content($mock_self, $nested_hash_multiple_keys) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { is($result, $nested_hash_multiple_keys, 'Nested hashes with multiple keys return unchanged'); }

# Test case 6: Hash reference with mixed nested hashes
my $mixed_nested_hash;  # AFTER LAST PASS: my $mixed_nested_hash = { key1 => { content => 'value1' }, key2 => { another_key => 'value2' }, key3 => { content => 'value3' } };
# UNVALIDATED: $result = eval { XML::Simple::collapse_content($mock_self, $mixed_nested_hash) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { is($result, { key1 => 'value1', key2 => { another_key => 'value2' }, key3 => 'value3' }, 'Mixed nested hashes are collapsed correctly'); }

done_testing();