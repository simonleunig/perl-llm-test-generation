use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::Push2"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'Push2 is defined'); }

# Mocking the Tie::IxHash object and its methods
my $mock_tie_ixhash = mock('Tie::IxHash', override => [
    Splice => sub {
        my ($self, $offset, $length, @values) = @_;
        splice(@{$self->[1]}, $offset, $length, @values);
        return scalar(@{$self->[1]});
    },
]);

# Test case 1: Adding key-value pairs to the hash
{
    my $tie_ixhash = bless [ [], [] ], 'Tie::IxHash';
    my $result = eval { Tie::IxHash::Push2($tie_ixhash, 'key1', 'value1', 'key2', 'value2') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 4, 'Push2 returns the correct length after adding key-value pairs');
        is_deeply($tie_ixhash->[1], ['key1', 'value1', 'key2', 'value2'], 'Hash contains the correct key-value pairs');
    }
}

# Test case 2: Adding no key-value pairs to the hash
{
    my $tie_ixhash = bless [ [], [] ], 'Tie::IxHash';
    my $result = eval { Tie::IxHash::Push2($tie_ixhash) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 0, 'Push2 returns the correct length when no key-value pairs are added');
        is_deeply($tie_ixhash->[1], [], 'Hash remains empty');
    }
}

# Test case 3: Adding key-value pairs to an empty hash
{
    my $tie_ixhash = bless [ [], [] ], 'Tie::IxHash';
    my $result = eval { Tie::IxHash::Push2($tie_ixhash, 'key1', 'value1') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 2, 'Push2 returns the correct length after adding the first key-value pair');
        is_deeply($tie_ixhash->[1], ['key1', 'value1'], 'Hash contains the correct key-value pair');
    }
}

# Test case 4: Adding multiple key-value pairs to an existing hash
{
    my $tie_ixhash = bless [ [], ['key1', 'value1'] ], 'Tie::IxHash';
    my $result = eval { Tie::IxHash::Push2($tie_ixhash, 'key2', 'value2', 'key3', 'value3') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 6, 'Push2 returns the correct length after adding multiple key-value pairs');
        is_deeply($tie_ixhash->[1], ['key1', 'value1', 'key2', 'value2', 'key3', 'value3'], 'Hash contains the correct key-value pairs');
    }
}

# Test case 5: Handling edge cases with invalid arguments
{
    my $tie_ixhash = bless [ [], [] ], 'Tie::IxHash';
    my $result = eval { Tie::IxHash::Push2($tie_ixhash, 'key1') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 0, 'Push2 returns the correct length when invalid arguments are provided');
        is_deeply($tie_ixhash->[1], [], 'Hash remains empty');
    }
}

done_testing();