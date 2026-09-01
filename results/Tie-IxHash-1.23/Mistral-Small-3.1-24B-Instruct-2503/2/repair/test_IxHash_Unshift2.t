use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Mock the Tie::IxHash object and its methods
my $mock;
eval { require Tie::IxHash; };
if ($@) {
    # DEPENDENCY MISSING: Tie::IxHash - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Tie::IxHash::new"}) {
        $mock = mock 'Tie::IxHash' => (
            override => [
                new => sub {
                    my $class = shift;
                    my $self = bless [], $class;
                    $self->[1] = [];  # Keys array
                    $self->[2] = [];  # Values array
                    return $self;
                },
                Splice => sub {
                    my ($self, $offset, $length, @pairs) = @_;
                    splice @{$self->[1]}, $offset, $length, map { $_->[0] } @pairs;
                    splice @{$self->[2]}, $offset, $length, map { $_->[1] } @pairs;
                },
            ],
        );
    } else {
        $mock = mock 'Tie::IxHash' => (
            add => [
                new => sub {
                    my $class = shift;
                    my $self = bless [], $class;
                    $self->[1] = [];  # Keys array
                    $self->[2] = [];  # Values array
                    return $self;
                },
                Splice => sub {
                    my ($self, $offset, $length, @pairs) = @_;
                    splice @{$self->[1]}, $offset, $length, map { $_->[0] } @pairs;
                    splice @{$self->[2]}, $offset, $length, map { $_->[1] } @pairs;
                },
            ],
        );
    }
}

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::Unshift2"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'Unshift2 is defined'); }

# Test case 1: Insert key-value pairs at the beginning
my $hash = eval { Tie::IxHash->new() };
if ($@) { fail('Function crashed: ' . $@); } else {
    my $result = eval { Tie::IxHash::Unshift2($hash, 'key1', 'value1', 'key2', 'value2') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 2, 'Unshift2 returns the correct number of key-value pairs');
        is_deeply([$hash->[1]], ['key1', 'key2'], 'Keys are inserted correctly');
        is_deeply([$hash->[2]], ['value1', 'value2'], 'Values are inserted correctly');
    }
}

# Test case 2: No key-value pairs provided
$hash = eval { Tie::IxHash->new() };
if ($@) { fail('Function crashed: ' . $@); } else {
    $hash->[1] = ['existing_key1', 'existing_key2'];
    $hash->[2] = ['existing_value1', 'existing_value2'];
    my $result = eval { Tie::IxHash::Unshift2($hash) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 2, 'Unshift2 returns the correct number of key-value pairs when no pairs are provided');
        is_deeply([$hash->[1]], ['existing_key1', 'existing_key2'], 'Keys remain unchanged');
        is_deeply([$hash->[2]], ['existing_value1', 'existing_value2'], 'Values remain unchanged');
    }
}

# Test case 3: Insert key-value pairs into an empty hash
$hash = eval { Tie::IxHash->new() };
if ($@) { fail('Function crashed: ' . $@); } else {
    my $result = eval { Tie::IxHash::Unshift2($hash, 'key3', 'value3') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 1, 'Unshift2 returns the correct number of key-value pairs when inserting into an empty hash');
        is_deeply([$hash->[1]], ['key3'], 'Key is inserted correctly');
        is_deeply([$hash->[2]], ['value3'], 'Value is inserted correctly');
    }
}

# Test case 4: Update existing keys with new values
$hash = eval { Tie::IxHash->new() };
if ($@) { fail('Function crashed: ' . $@); } else {
    $hash->[1] = ['key1', 'key2'];
    $hash->[2] = ['value1', 'value2'];
    my $result = eval { Tie::IxHash::Unshift2($hash, 'key1', 'new_value1', 'key3', 'value3') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 3, 'Unshift2 returns the correct number of key-value pairs after updating existing keys');
        is_deeply([$hash->[1]], ['key1', 'key3', 'key2'], 'Keys are updated correctly');
        is_deeply([$hash->[2]], ['new_value1', 'value3', 'value2'], 'Values are updated correctly');
    }
}

done_testing();