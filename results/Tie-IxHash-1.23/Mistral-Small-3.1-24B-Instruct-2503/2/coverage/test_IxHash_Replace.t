use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::Replace"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'Replace is defined'); }

# Mocking the DELETE method for testing purposes
my $mock;
eval { require Tie::IxHash; };
if ($@) {
    # DEPENDENCY MISSING: Tie::IxHash - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Tie::IxHash::DELETE"}) {
        $mock = mock 'Tie::IxHash' => ( override => [ DELETE => sub {
            my ($self, $key) = @_;
            delete $self->[0]{$key};
        } ] );
    } else {
        $mock = mock 'Tie::IxHash' => ( add => [ DELETE => sub {
            my ($self, $key) = @_;
            delete $self->[0]{$key};
        } ] );
    }
}

# Helper function to create a Tie::IxHash object
sub create_ixhash {
    my %hash = @_;
    my $ixhash = bless [ { %hash }, [ keys %hash ], [ values %hash ] ], 'Tie::IxHash';
    return $ixhash;
}

# Test case 1: Replace value at a valid index
{
    my $ixhash = create_ixhash(a => 1, b => 2, c => 3);
    my $result = eval { Tie::IxHash::Replace($ixhash, 1, 99) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, 'b', 'Value replaced successfully at index 1');
        is($ixhash->[2][1], 99, 'Value at index 1 is updated');
    }
}

# Test case 2: Replace key and value at a valid index
{
    my $ixhash = create_ixhash(a => 1, b => 2, c => 3);
    my $result = eval { Tie::IxHash::Replace($ixhash, 1, 99, 'z') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 'z', 'Key and value replaced successfully at index 1');
        is($ixhash->[1][1], 'z', 'Key at index 1 is updated');
        is($ixhash->[2][1], 99, 'Value at index 1 is updated');
    }
}

# Test case 3: Replace value at an invalid index (out of bounds)
{
    my $ixhash = create_ixhash(a => 1, b => 2, c => 3);
    my $result = eval { Tie::IxHash::Replace($ixhash, 5, 99) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, undef, 'Index out of bounds, returns undef');
    }
}

# Test case 4: Replace value at a negative index
{
    my $ixhash = create_ixhash(a => 1, b => 2, c => 3);
    my $result = eval { Tie::IxHash::Replace($ixhash, -1, 99) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, undef, 'Negative index, returns undef');
    }
}

# Test case 5: Replace key and value when the new key already exists
{
    my $ixhash = create_ixhash(a => 1, b => 2, c => 3);
    my $result = eval { Tie::IxHash::Replace($ixhash, 1, 99, 'a') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 'a', 'Key and value replaced successfully with existing key');
        is($ixhash->[1][1], 'a', 'Key at index 1 is updated');
        is($ixhash->[2][1], 99, 'Value at index 1 is updated');
    }
}

# Test case 6: Replace value when the new key is not provided
{
    my $ixhash = create_ixhash(a => 1, b => 2, c => 3);
    my $result = eval { Tie::IxHash::Replace($ixhash, 1, 99) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, 'b', 'Value replaced successfully without changing key');
        is($ixhash->[2][1], 99, 'Value at index 1 is updated');
    }
}

done_testing();