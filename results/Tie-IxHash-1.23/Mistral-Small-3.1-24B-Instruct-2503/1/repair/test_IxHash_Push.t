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

# Mocking the STORE method
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
                    $self->{keys}->[$self->{count}] = $key;
                    $self->{values}->[$self->{count}] = $value;
                    $self->{count}++;
                }
            ]
        );
    } else {
        $mock = mock 'Tie::IxHash' => (
            add => [
                STORE => sub {
                    my ($self, $key, $value) = @_;
                    $self->{keys}->[$self->{count}] = $key;
                    $self->{values}->[$self->{count}] = $value;
                    $self->{count}++;
                }
            ]
        );
    }
}

# Test case: Adding key-value pairs
{
    my $hash = bless { keys => [], values => [], count => 0 }, 'Tie::IxHash';
    my $result = eval { Tie::IxHash::Push($hash, 'key1', 'value1', 'key2', 'value2') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 2, 'Push returns correct number of elements');
        is($hash->{keys}->[0], 'key1', 'First key is correct');
        is($hash->{values}->[0], 'value1', 'First value is correct');
        is($hash->{keys}->[1], 'key2', 'Second key is correct');
        is($hash->{values}->[1], 'value2', 'Second value is correct');
    }
}

# Test case: Adding no key-value pairs
{
    my $hash = bless { keys => [], values => [], count => 0 }, 'Tie::IxHash';
    my $result = eval { Tie::IxHash::Push($hash) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 0, 'Push returns 0 when no key-value pairs are provided');
        is(scalar(@{$hash->{keys}}), 0, 'No keys added');
        is(scalar(@{$hash->{values}}), 0, 'No values added');
    }
}

# Test case: Updating existing key
{
    my $hash = bless { keys => ['key1'], values => ['value1'], count => 1 }, 'Tie::IxHash';
    my $result = eval { Tie::IxHash::Push($hash, 'key1', 'value2') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 1, 'Push returns correct number of elements');
        is($hash->{keys}->[0], 'key1', 'Key remains the same');
        is($hash->{values}->[0], 'value2', 'Value is updated');
    }
}

# Test case: Adding multiple key-value pairs
{
    my $hash = bless { keys => [], values => [], count => 0 }, 'Tie::IxHash';
    my $result = eval { Tie::IxHash::Push($hash, 'key1', 'value1', 'key2', 'value2', 'key3', 'value3') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 3, 'Push returns correct number of elements');
        is($hash->{keys}->[0], 'key1', 'First key is correct');
        is($hash->{values}->[0], 'value1', 'First value is correct');
        is($hash->{keys}->[1], 'key2', 'Second key is correct');
        is($hash->{values}->[1], 'value2', 'Second value is correct');
        is($hash->{keys}->[2], 'key3', 'Third key is correct');
        is($hash->{values}->[2], 'value3', 'Third value is correct');
    }
}

done_testing();