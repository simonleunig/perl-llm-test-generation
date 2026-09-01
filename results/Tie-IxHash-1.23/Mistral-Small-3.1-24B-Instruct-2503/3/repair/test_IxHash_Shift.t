use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::Shift"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'Shift is defined'); }

# Helper function to create a Tie::IxHash object
sub create_ixhash {
    my %hash = @_;
    my $ixhash = bless { %hash }, 'Tie::IxHash';
    return $ixhash;
}

# Test case: Shift on an empty hash
{
    my $ixhash = create_ixhash();
    my $result = eval { Tie::IxHash::Shift($ixhash) };
    if ($@) { fail('Shift crashed on empty hash: ' . $@); }
    else {
        is($result, undef, 'Shift returns undef on empty hash');
    }
}

# Test case: Shift on a hash with one element
{
    my $ixhash = create_ixhash(a => 1);
    my $result = eval { Tie::IxHash::Shift($ixhash) };
    if ($@) { fail('Shift crashed on single element hash: ' . $@); }
    else {
        is_deeply($result, ['a', 1], 'Shift returns correct key-value pair on single element hash');
        is_deeply($ixhash, create_ixhash(), 'Hash is empty after shift');
    }
}

# Test case: Shift on a hash with multiple elements
{
    my $ixhash = create_ixhash(a => 1, b => 2, c => 3);
    my $result = eval { Tie::IxHash::Shift($ixhash) };
    if ($@) { fail('Shift crashed on multiple element hash: ' . $@); }
    else {
        is_deeply($result, ['a', 1], 'Shift returns correct key-value pair on multiple element hash');
        is_deeply($ixhash, create_ixhash(b => 2, c => 3), 'Hash is updated correctly after shift');
    }
}

# Test case: Shift on a hash with multiple elements, multiple shifts
{
    my $ixhash = create_ixhash(a => 1, b => 2, c => 3);
    my $result1 = eval { Tie::IxHash::Shift($ixhash) };
    my $result2 = eval { Tie::IxHash::Shift($ixhash) };
    my $result3 = eval { Tie::IxHash::Shift($ixhash) };
    if ($@) { fail('Shift crashed on multiple shifts: ' . $@); }
    else {
        is_deeply($result1, ['a', 1], 'First shift returns correct key-value pair');
        is_deeply($result2, ['b', 2], 'Second shift returns correct key-value pair');
        is_deeply($result3, ['c', 3], 'Third shift returns correct key-value pair');
        is_deeply($ixhash, create_ixhash(), 'Hash is empty after all shifts');
    }
}

done_testing();