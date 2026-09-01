use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }  # Use actual module name from package declaration

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::hash_to_array"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'hash_to_array is defined'); }

# Mock dependencies
mock 'XML::Simple' => (
    copy_hash => sub {
        my ($self, $hashref, %extra) = @_;
        my $copy = { %$hashref, %extra };
        return $copy;
    },
);

# Test case 1: Normal operation with keyattr as a hash
{
    my $self = bless { opt => { keyattr => { parent => ['key'] }, nosort => 0 } }, 'XML::Simple';
    my $parent = 'parent';
    my $hashref = {
        key1 => { value1 => 'val1' },
        key2 => { value2 => 'val2' },
    };
    my $expected = [
        { key => 'key1', value1 => 'val1' },
        { key => 'key2', value2 => 'val2' },
    ];

    my $result = eval { XML::Simple::hash_to_array($self, $parent, $hashref) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, $expected, 'hash_to_array returns correct array with keyattr as hash');
    }
}

# Test case 2: Normal operation with keyattr as an array
{
    my $self = bless { opt => { keyattr => ['key'], nosort => 0 } }, 'XML::Simple';
    my $parent = 'parent';
    my $hashref = {
        key1 => { value1 => 'val1' },
        key2 => { value2 => 'val2' },
    };
    my $expected = [
        { key => 'key1', value1 => 'val1' },
        { key => 'key2', value2 => 'val2' },
    ];

    my $result = eval { XML::Simple::hash_to_array($self, $parent, $hashref) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, $expected, 'hash_to_array returns correct array with keyattr as array');
    }
}

# Test case 3: Empty hashref
{
    my $self = bless { opt => { keyattr => ['key'], nosort => 0 } }, 'XML::Simple';
    my $parent = 'parent';
    my $hashref = {};

    my $result = eval { XML::Simple::hash_to_array($self, $parent, $hashref) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, [], 'hash_to_array returns empty array for empty hashref');
    }
}

# Test case 4: Nested values that are not hashes
{
    my $self = bless { opt => { keyattr => ['key'], nosort => 0 } }, 'XML::Simple';
    my $parent = 'parent';
    my $hashref = {
        key1 => 'not_a_hash',
    };

    my $result = eval { XML::Simple::hash_to_array($self, $parent, $hashref) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, $hashref, 'hash_to_array returns original hashref when nested values are not hashes');
    }
}

# Test case 5: Key attributes not defined
{
    my $self = bless { opt => { keyattr => undef, nosort => 0 } }, 'XML::Simple';
    my $parent = 'parent';
    my $hashref = {
        key1 => { value1 => 'val1' },
    };

    my $result = eval { XML::Simple::hash_to_array($self, $parent, $hashref) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, $hashref, 'hash_to_array returns original hashref when key attributes are not defined');
    }
}

# Test case 6: Key attributes not unique
{
    my $self = bless { opt => { keyattr => ['key'], nosort => 0 } }, 'XML::Simple';
    my $parent = 'parent';
    my $hashref = {
        key1 => { value1 => 'val1' },
        key1 => { value2 => 'val2' },  # Duplicate key
    };

    my $result = eval { XML::Simple::hash_to_array($self, $parent, $hashref) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, $hashref, 'hash_to_array handles duplicate keys correctly');
    }
}

done_testing();
