use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::Push"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'Push is defined'); }

# Mocking the STORE method for Tie::IxHash
my $mock;
eval { require Tie::IxHash; };
if ($@) {
    # DEPENDENCY MISSING: Tie::IxHash - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Tie::IxHash::STORE"}) {
        $mock = mock 'Tie::IxHash' => (
            override => [
                STORE => sub {
                    my ($self, $key, $value) = @_;
                    $self->{data}->{$key} = $value;
                    push @{$self->{keys}}, $key;
                }
            ]
        );
    } else {
        $mock = mock 'Tie::IxHash' => (
            add => [
                STORE => sub {
                    my ($self, $key, $value) = @_;
                    $self->{data}->{$key} = $value;
                    push @{$self->{keys}}, $key;
                }
            ]
        );
    }
}

# Test case: Adding key-value pairs to the hash
{
    my $hash = bless { data => {}, keys => [] }, 'Tie::IxHash';
    my $result = eval { Tie::IxHash::Push($hash, 'key1', 'value1', 'key2', 'value2') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 2, 'Push returns the correct number of elements');
        is($hash->{data}->{key1}, 'value1', 'Key-value pair added correctly');
        is($hash->{data}->{key2}, 'value2', 'Key-value pair added correctly');
        is_deeply($hash->{keys}, ['key1', 'key2'], 'Keys are in the correct order');
    }
}

# Test case: Adding a single key-value pair
{
    my $hash = bless { data => {}, keys => [] }, 'Tie::IxHash';
    my $result = eval { Tie::IxHash::Push($hash, 'key1', 'value1') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 1, 'Push returns the correct number of elements');
        is($hash->{data}->{key1}, 'value1', 'Key-value pair added correctly');
        is_deeply($hash->{keys}, ['key1'], 'Keys are in the correct order');
    }
}

# Test case: Adding no key-value pairs
{
    my $hash = bless { data => {}, keys => [] }, 'Tie::IxHash';
    my $result = eval { Tie::IxHash::Push($hash) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 0, 'Push returns the correct number of elements when no pairs are added');
        is_deeply($hash->{data}, {}, 'Hash remains unchanged');
        is_deeply($hash->{keys}, [], 'Keys remain unchanged');
    }
}

# Test case: Updating an existing key
{
    my $hash = bless { data => { key1 => 'old_value' }, keys => ['key1'] }, 'Tie::IxHash';
    my $result = eval { Tie::IxHash::Push($hash, 'key1', 'new_value') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 1, 'Push returns the correct number of elements');
        is($hash->{data}->{key1}, 'new_value', 'Key-value pair updated correctly');
        is_deeply($hash->{keys}, ['key1'], 'Keys remain in the correct order');
    }
}

# Test case: Adding multiple key-value pairs
{
    my $hash = bless { data => {}, keys => [] }, 'Tie::IxHash';
    my $result = eval { Tie::IxHash::Push($hash, 'key1', 'value1', 'key2', 'value2', 'key3', 'value3') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 3, 'Push returns the correct number of elements');
        is($hash->{data}->{key1}, 'value1', 'Key-value pair added correctly');
        is($hash->{data}->{key2}, 'value2', 'Key-value pair added correctly');
        is($hash->{data}->{key3}, 'value3', 'Key-value pair added correctly');
        is_deeply($hash->{keys}, ['key1', 'key2', 'key3'], 'Keys are in the correct order');
    }
}

done_testing();