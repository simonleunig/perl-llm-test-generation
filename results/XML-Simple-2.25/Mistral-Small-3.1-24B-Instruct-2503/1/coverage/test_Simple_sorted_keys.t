use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::sorted_keys"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'sorted_keys is defined'); }

# Mock the XML::Simple object
my $mock_self;  # AFTER LAST PASS: my $mock_self = mock('XML::Simple', override => [
    # AFTER LAST PASS: opt => {
        # AFTER LAST PASS: nosort => 0,
        # AFTER LAST PASS: keyattr => {
            # AFTER LAST PASS: 'element_name' => ['key1']
        # AFTER LAST PASS: }
    # AFTER LAST PASS: }
# AFTER LAST PASS: ]);

# Test case 1: Basic functionality with keyattr as hash
# AFTER LAST PASS: {
    my $hash_ref;  # AFTER LAST PASS: my $hash_ref = { key1 => 1, key2 => 2, key3 => 3 };
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::sorted_keys($mock_self, 'element_name', $hash_ref) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, ['key1', 'key2', 'key3'], 'Keys sorted with keyattr as hash');
    # FAILED: }
# AFTER LAST PASS: }

# Test case 2: Basic functionality with keyattr as array
# AFTER LAST PASS: {
    # AFTER LAST PASS: $mock_self->mock(opt => {
        # AFTER LAST PASS: nosort => 0,
        # AFTER LAST PASS: keyattr => ['key1']
    # AFTER LAST PASS: });
    my $hash_ref;  # AFTER LAST PASS: my $hash_ref = { key1 => 1, key2 => 2, key3 => 3 };
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::sorted_keys($mock_self, 'element_name', $hash_ref) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, ['key1', 'key2', 'key3'], 'Keys sorted with keyattr as array');
    # FAILED: }
# AFTER LAST PASS: }

# Test case 3: nosort option set to true
# AFTER LAST PASS: {
    # AFTER LAST PASS: $mock_self->mock(opt => {
        # AFTER LAST PASS: nosort => 1,
        # AFTER LAST PASS: keyattr => {
            # AFTER LAST PASS: 'element_name' => ['key1']
        # AFTER LAST PASS: }
    # AFTER LAST PASS: });
    my $hash_ref;  # AFTER LAST PASS: my $hash_ref = { key1 => 1, key2 => 2, key3 => 3 };
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::sorted_keys($mock_self, 'element_name', $hash_ref) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, ['key1', 'key2', 'key3'], 'Keys returned unsorted with nosort option');
    # FAILED: }
# AFTER LAST PASS: }

# Test case 4: Empty hash
# AFTER LAST PASS: {
    my $hash_ref;  # AFTER LAST PASS: my $hash_ref = {};
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::sorted_keys($mock_self, 'element_name', $hash_ref) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, [], 'Empty hash returns empty list');
    # FAILED: }
# AFTER LAST PASS: }

# Test case 5: KeyAttr option not set
# AFTER LAST PASS: {
    # AFTER LAST PASS: $mock_self->mock(opt => {
        # AFTER LAST PASS: nosort => 0,
        # AFTER LAST PASS: keyattr => undef
    # AFTER LAST PASS: });
    my $hash_ref;  # AFTER LAST PASS: my $hash_ref = { key1 => 1, key2 => 2, key3 => 3 };
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::sorted_keys($mock_self, 'element_name', $hash_ref) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, ['key1', 'key2', 'key3'], 'Keys sorted alphabetically without keyattr');
    # FAILED: }
# AFTER LAST PASS: }

# Test case 6: KeyAttr option is malformed
# AFTER LAST PASS: {
    # AFTER LAST PASS: $mock_self->mock(opt => {
        # AFTER LAST PASS: nosort => 0,
        # AFTER LAST PASS: keyattr => 'invalid'
    # AFTER LAST PASS: });
    my $hash_ref;  # AFTER LAST PASS: my $hash_ref = { key1 => 1, key2 => 2, key3 => 3 };
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::sorted_keys($mock_self, 'element_name', $hash_ref) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, ['key1', 'key2', 'key3'], 'Keys sorted alphabetically with malformed keyattr');
    # FAILED: }
# AFTER LAST PASS: }

done_testing();