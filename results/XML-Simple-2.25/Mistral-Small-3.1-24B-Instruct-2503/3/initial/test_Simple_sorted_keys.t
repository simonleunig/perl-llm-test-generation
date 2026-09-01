use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }  # Use actual module name from package declaration

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::sorted_keys"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'sorted_keys is defined'); }

# Mock the XML::Simple object
my $mock_self = mock('XML::Simple', override => [
    opt => {
        nosort => 0,
        keyattr => {
            'element_name' => ['key1']
        }
    }
]);

# Test case 1: Basic functionality with keyattr as a hash
{
    my $hash_ref = { key1 => 1, key2 => 2, key3 => 3 };
    my $result = eval { XML::Simple::sorted_keys($mock_self, 'element_name', $hash_ref) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, ['key1', 'key2', 'key3'], 'Keys sorted correctly with keyattr as hash');
    }
}

# Test case 2: Basic functionality with keyattr as an array
{
    $mock_self->mock(opt => { keyattr => ['key1'] });
    my $hash_ref = { key1 => 1, key2 => 2, key3 => 3 };
    my $result = eval { XML::Simple::sorted_keys($mock_self, 'element_name', $hash_ref) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, ['key1', 'key2', 'key3'], 'Keys sorted correctly with keyattr as array');
    }
}

# Test case 3: nosort option is true
{
    $mock_self->mock(opt => { nosort => 1 });
    my $hash_ref = { key1 => 1, key2 => 2, key3 => 3 };
    my $result = eval { XML::Simple::sorted_keys($mock_self, 'element_name', $hash_ref) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, ['key1', 'key2', 'key3'], 'Keys returned in original order with nosort option');
    }
}

# Test case 4: Empty hash
{
    my $hash_ref = {};
    my $result = eval { XML::Simple::sorted_keys($mock_self, 'element_name', $hash_ref) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, [], 'Empty hash returns empty list');
    }
}

# Test case 5: KeyAttr option is not set
{
    $mock_self->mock(opt => { keyattr => undef });
    my $hash_ref = { key1 => 1, key2 => 2, key3 => 3 };
    my $result = eval { XML::Simple::sorted_keys($mock_self, 'element_name', $hash_ref) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, ['key1', 'key2', 'key3'], 'Keys sorted alphabetically when keyattr is not set');
    }
}

# Test case 6: KeyAttr option is malformed
{
    $mock_self->mock(opt => { keyattr => 'invalid' });
    my $hash_ref = { key1 => 1, key2 => 2, key3 => 3 };
    my $result = eval { XML::Simple::sorted_keys($mock_self, 'element_name', $hash_ref) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, ['key1', 'key2', 'key3'], 'Keys sorted alphabetically with malformed keyattr');
    }
}

# Test case 7: KeyAttr option is a hash but the specified key does not exist
{
    $mock_self->mock(opt => { keyattr => { 'element_name' => ['nonexistent_key'] } });
    my $hash_ref = { key1 => 1, key2 => 2, key3 => 3 };
    my $result = eval { XML::Simple::sorted_keys($mock_self, 'element_name', $hash_ref) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, ['key1', 'key2', 'key3'], 'Keys sorted alphabetically when key does not exist');
    }
}

done_testing();
