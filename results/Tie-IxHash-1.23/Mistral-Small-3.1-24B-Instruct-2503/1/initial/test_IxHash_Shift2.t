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

# Mocking the Splice method for testing purposes
mock 'Tie::IxHash', splice => sub {
    my ($self, $offset, $length) = @_;
    my @keys = keys %$self;
    my @values = values %$self;
    my @removed = splice @keys, $offset, $length;
    splice @values, $offset, $length;
    return ($removed[0], $values[$offset]);
};

# Test case: Shift2 on an empty Tie::IxHash object
{
    my $hash = {};
    tie %$hash, 'Tie::IxHash';
    my $result = eval { Tie::IxHash::Shift2($hash) };
    if ($@) { fail('Shift2 crashed on empty hash: ' . $@); }
    else { is($result, undef, 'Shift2 returns undef on empty hash'); }
}

# Test case: Shift2 on a non-empty Tie::IxHash object
{
    my $hash = { a => 1, b => 2, c => 3 };
    tie %$hash, 'Tie::IxHash';
    my $result = eval { Tie::IxHash::Shift2($hash) };
    if ($@) { fail('Shift2 crashed on non-empty hash: ' . $@); }
    else {
        is($result, ['a', 1], 'Shift2 returns the first key-value pair');
        is(scalar(keys %$hash), 2, 'Hash has one less key after Shift2');
    }
}

# Test case: Shift2 on a Tie::IxHash object with one element
{
    my $hash = { d => 4 };
    tie %$hash, 'Tie::IxHash';
    my $result = eval { Tie::IxHash::Shift2($hash) };
    if ($@) { fail('Shift2 crashed on single-element hash: ' . $@); }
    else {
        is($result, ['d', 4], 'Shift2 returns the single key-value pair');
        is(scalar(keys %$hash), 0, 'Hash is empty after Shift2');
    }
}

# Test case: Shift2 on an invalid object
{
    my $invalid_object = 'not_a_hash';
    my $result = eval { Tie::IxHash::Shift2($invalid_object) };
    if ($@) { fail('Shift2 crashed on invalid object: ' . $@); }
    else { is($result, undef, 'Shift2 returns undef on invalid object'); }
}

done_testing();
