use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }  # Use actual module name from package declaration

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::Shift2"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'Shift2 is defined'); }

# Mocking the Tie::IxHash::Splice method
mock 'Tie::IxHash', splice => sub {
    my ($self, $offset, $length) = @_;
    if ($offset == 0 && $length == 1) {
        return (shift @{$self->{_order}}, delete $self->{_hash}{shift @{$self->{_order}}});
    }
    return ();
};

# Test case: Shift2 on an empty Tie::IxHash object
{
    my $hash = bless { _order => [], _hash => {} }, 'Tie::IxHash';
    my $result = eval { Tie::IxHash::Shift2($hash) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, undef, 'Shift2 returns undef on empty hash');
    }
}

# Test case: Shift2 on a non-empty Tie::IxHash object
{
    my $hash = bless { _order => ['key1', 'key2'], _hash => { key1 => 'value1', key2 => 'value2' } }, 'Tie::IxHash';
    my $result = eval { Tie::IxHash::Shift2($hash) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, ['key1', 'value1'], 'Shift2 returns the first key-value pair');
        is_deeply($hash->{_order}, ['key2'], 'The order array is updated correctly');
        is_deeply($hash->{_hash}, { key2 => 'value2' }, 'The hash is updated correctly');
    }
}

# Test case: Shift2 on a Tie::IxHash object with one element
{
    my $hash = bless { _order => ['key1'], _hash => { key1 => 'value1' } }, 'Tie::IxHash';
    my $result = eval { Tie::IxHash::Shift2($hash) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, ['key1', 'value1'], 'Shift2 returns the single key-value pair');
        is_deeply($hash->{_order}, [], 'The order array is empty after removal');
        is_deeply($hash->{_hash}, {}, 'The hash is empty after removal');
    }
}

# Test case: Shift2 on a Tie::IxHash object with multiple elements
{
    my $hash = bless { _order => ['key1', 'key2', 'key3'], _hash => { key1 => 'value1', key2 => 'value2', key3 => 'value3' } }, 'Tie::IxHash';
    my $result = eval { Tie::IxHash::Shift2($hash) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, ['key1', 'value1'], 'Shift2 returns the first key-value pair');
        is_deeply($hash->{_order}, ['key2', 'key3'], 'The order array is updated correctly');
        is_deeply($hash->{_hash}, { key2 => 'value2', key3 => 'value3' }, 'The hash is updated correctly');
    }
}

done_testing();
