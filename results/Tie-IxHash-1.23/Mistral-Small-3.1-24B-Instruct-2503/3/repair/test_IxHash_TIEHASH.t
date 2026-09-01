use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::TIEHASH"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'TIEHASH is defined'); }

# Mock the Push method since it's used internally
my $mock;
eval { require Tie::IxHash; };
if ($@) {
    # DEPENDENCY MISSING: Tie::IxHash - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Tie::IxHash::Push"}) {
        $mock = mock 'Tie::IxHash::Push' => sub {
            my ($self, @pairs) = @_;
            while (@pairs) {
                my $key = shift @pairs;
                my $value = shift @pairs;
                $self->[0]->{$key} = $value;
                push @{$self->[1]}, $key;
                push @{$self->[2]}, $value;
            }
        };
    } else {
        $mock = mock 'Tie::IxHash' => ( add => [ 'Push' => sub {
            my ($self, @pairs) = @_;
            while (@pairs) {
                my $key = shift @pairs;
                my $value = shift @pairs;
                $self->[0]->{$key} = $value;
                push @{$self->[1]}, $key;
                push @{$self->[2]}, $value;
            }
        }] );
    }
}

# Test case: No initial key-value pairs
my $result = eval { Tie::IxHash::TIEHASH('Tie::IxHash') };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'TIEHASH returns result when no initial pairs are provided');
    is(ref($result), 'ARRAY', 'Result is an array reference');
    is(scalar(@{$result}), 4, 'Array has 4 elements');
    is(ref($result->[0]), 'HASH', 'First element is a hash reference');
    is(ref($result->[1]), 'ARRAY', 'Second element is an array reference');
    is(ref($result->[2]), 'ARRAY', 'Third element is an array reference');
    is($result->[3], 0, 'Fourth element is 0');
}

# Test case: With initial key-value pairs
$result = eval { Tie::IxHash::TIEHASH('Tie::IxHash', 'key1' => 'value1', 'key2' => 'value2') };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'TIEHASH returns result when initial pairs are provided');
    is(ref($result), 'ARRAY', 'Result is an array reference');
    is(scalar(@{$result}), 4, 'Array has 4 elements');
    is(ref($result->[0]), 'HASH', 'First element is a hash reference');
    is(ref($result->[1]), 'ARRAY', 'Second element is an array reference');
    is(ref($result->[2]), 'ARRAY', 'Third element is an array reference');
    is($result->[3], 0, 'Fourth element is 0');
    is($result->[0]->{'key1'}, 'value1', 'Key-value pair key1 => value1 is stored');
    is($result->[0]->{'key2'}, 'value2', 'Key-value pair key2 => value2 is stored');
    is($result->[1]->[0], 'key1', 'First key is key1');
    is($result->[1]->[1], 'key2', 'Second key is key2');
    is($result->[2]->[0], 'value1', 'First value is value1');
    is($result->[2]->[1], 'value2', 'Second value is value2');
}

# Test case: Invalid class name
$result = eval { Tie::IxHash::TIEHASH('InvalidClass') };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'TIEHASH returns result with invalid class name');
    is(ref($result), 'ARRAY', 'Result is an array reference');
    is(scalar(@{$result}), 4, 'Array has 4 elements');
    is(ref($result->[0]), 'HASH', 'First element is a hash reference');
    is(ref($result->[1]), 'ARRAY', 'Second element is an array reference');
    is(ref($result->[2]), 'ARRAY', 'Third element is an array reference');
    is($result->[3], 0, 'Fourth element is 0');
}

done_testing();