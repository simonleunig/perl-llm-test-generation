use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::DELETE"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'DELETE is defined'); }

# Helper function to create a Tie::IxHash object
sub create_ixhash {
    my @keys = @_;
    my %hash;
    tie %hash, 'Tie::IxHash';
    for my $key (@keys) {
        $hash{$key} = $key;
    }
    return \%hash;
}

# Test case: Key exists in the hash
{
    my $hash = create_ixhash(qw(a b c));
    my $result = eval { Tie::IxHash::DELETE($hash, 'b') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 'b', 'DELETE returns the correct value when key exists');
        is(scalar(keys %$hash), 2, 'Hash has the correct number of keys after deletion');
        ok(!exists $hash->{b}, 'Key is deleted from the hash');
    }
}

# Test case: Key does not exist in the hash
{
    my $hash = create_ixhash(qw(a b c));
    my $result = eval { Tie::IxHash::DELETE($hash, 'd') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, undef, 'DELETE returns undef when key does not exist');
        is(scalar(keys %$hash), 3, 'Hash remains unchanged when key does not exist');
    }
}

# Test case: Key is the first element in the hash
{
    my $hash = create_ixhash(qw(a b c));
    my $result = eval { Tie::IxHash::DELETE($hash, 'a') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 'a', 'DELETE returns the correct value when key is the first element');
        is(scalar(keys %$hash), 2, 'Hash has the correct number of keys after deletion');
        ok(!exists $hash->{a}, 'First key is deleted from the hash');
    }
}

# Test case: Key is the last element in the hash
{
    my $hash = create_ixhash(qw(a b c));
    my $result = eval { Tie::IxHash::DELETE($hash, 'c') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 'c', 'DELETE returns the correct value when key is the last element');
        is(scalar(keys %$hash), 2, 'Hash has the correct number of keys after deletion');
        ok(!exists $hash->{c}, 'Last key is deleted from the hash');
    }
}

# Test case: Hash is empty
{
    my $hash = create_ixhash();
    my $result = eval { Tie::IxHash::DELETE($hash, 'a') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, undef, 'DELETE returns undef when hash is empty');
        is(scalar(keys %$hash), 0, 'Hash remains empty after deletion attempt');
    }
}

done_testing();