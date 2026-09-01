use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::Pop2"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'Pop2 is defined'); }

# Mocking the Splice method for testing purposes
my $mock;
eval { require Tie::IxHash; };
if ($@) {
    # DEPENDENCY MISSING: Tie::IxHash - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Tie::IxHash::Splice"}) {
        $mock = mock 'Tie::IxHash' => ( override => [ splice => sub {
            my $self = shift;
            my $index = shift;
            my $count = shift || 1;
            my $list = $self->{_list};
            my $hash = $self->{_hash};

            if ($index == -1) {
                return pop @$list;
            } else {
                return splice @$list, $index, $count;
            }
        } ] );
    } else {
        $mock = mock 'Tie::IxHash' => ( add => [ splice => sub {
            my $self = shift;
            my $index = shift;
            my $count = shift || 1;
            my $list = $self->{_list};
            my $hash = $self->{_hash};

            if ($index == -1) {
                return pop @$list;
            } else {
                return splice @$list, $index, $count;
            }
        } ] );
    }
}

# Test case: Pop2 on an empty Tie::IxHash object
{
    my $hash = bless { _list => [], _hash => {} }, 'Tie::IxHash';
    my $result = eval { Tie::IxHash::Pop2($hash) };
    if ($@) { fail('Pop2 crashed on empty hash: ' . $@); } else {
        is($result, undef, 'Pop2 returns undef on empty hash');
    }
}

# Test case: Pop2 on a non-empty Tie::IxHash object
{
    my $hash = bless { _list => [['key1', 'value1'], ['key2', 'value2']], _hash => { key1 => 'value1', key2 => 'value2' } }, 'Tie::IxHash';
    my $result = eval { Tie::IxHash::Pop2($hash) };
    if ($@) { fail('Pop2 crashed on non-empty hash: ' . $@); } else {
        is_deeply($result, ['key2', 'value2'], 'Pop2 returns the last key-value pair');
        is_deeply($hash->{_list}, [['key1', 'value1']], 'The last key-value pair is removed from the list');
        is_deeply($hash->{_hash}, { key1 => 'value1' }, 'The last key-value pair is removed from the hash');
    }
}

# Test case: Pop2 on a Tie::IxHash object with one element
{
    my $hash = bless { _list => [['key1', 'value1']], _hash => { key1 => 'value1' } }, 'Tie::IxHash';
    my $result = eval { Tie::IxHash::Pop2($hash) };
    if ($@) { fail('Pop2 crashed on single-element hash: ' . $@); } else {
        is_deeply($result, ['key1', 'value1'], 'Pop2 returns the single key-value pair');
        is_deeply($hash->{_list}, [], 'The single key-value pair is removed from the list');
        is_deeply($hash->{_hash}, {}, 'The single key-value pair is removed from the hash');
    }
}

# Test case: Pop2 on a Tie::IxHash object with multiple elements
{
    my $hash = bless { _list => [['key1', 'value1'], ['key2', 'value2'], ['key3', 'value3']], _hash => { key1 => 'value1', key2 => 'value2', key3 => 'value3' } }, 'Tie::IxHash';
    my $result = eval { Tie::IxHash::Pop2($hash) };
    if ($@) { fail('Pop2 crashed on multi-element hash: ' . $@); } else {
        is_deeply($result, ['key3', 'value3'], 'Pop2 returns the last key-value pair');
        is_deeply($hash->{_list}, [['key1', 'value1'], ['key2', 'value2']], 'The last key-value pair is removed from the list');
        is_deeply($hash->{_hash}, { key1 => 'value1', key2 => 'value2' }, 'The last key-value pair is removed from the hash');
    }
}

done_testing();