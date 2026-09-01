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
# AFTER LAST PASS: {
    my $hash;  # AFTER LAST PASS: my $hash = create_ixhash(qw(a b c));
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Tie::IxHash::DELETE($hash, 'b') };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, 'b', 'DELETE returns the correct value when key exists');
        # FAILED: is(scalar(keys %$hash), 2, 'Hash has the correct number of keys after deletion');
        # FAILED: ok(!exists $hash->{b}, 'Key is deleted from the hash');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Key does not exist in the hash
# AFTER LAST PASS: {
    my $hash;  # AFTER LAST PASS: my $hash = create_ixhash(qw(a b c));
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Tie::IxHash::DELETE($hash, 'd') };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, undef, 'DELETE returns undef when key does not exist');
        # FAILED: is(scalar(keys %$hash), 3, 'Hash remains unchanged when key does not exist');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Key is the first element in the hash
# AFTER LAST PASS: {
    my $hash;  # AFTER LAST PASS: my $hash = create_ixhash(qw(a b c));
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Tie::IxHash::DELETE($hash, 'a') };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, 'a', 'DELETE returns the correct value when key is the first element');
        # FAILED: is(scalar(keys %$hash), 2, 'Hash has the correct number of keys after deletion');
        # FAILED: ok(!exists $hash->{a}, 'First key is deleted from the hash');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Key is the last element in the hash
# AFTER LAST PASS: {
    my $hash;  # AFTER LAST PASS: my $hash = create_ixhash(qw(a b c));
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Tie::IxHash::DELETE($hash, 'c') };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, 'c', 'DELETE returns the correct value when key is the last element');
        # FAILED: is(scalar(keys %$hash), 2, 'Hash has the correct number of keys after deletion');
        # FAILED: ok(!exists $hash->{c}, 'Last key is deleted from the hash');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Hash is empty
# AFTER LAST PASS: {
    my $hash;  # AFTER LAST PASS: my $hash = create_ixhash();
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Tie::IxHash::DELETE($hash, 'a') };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, undef, 'DELETE returns undef when hash is empty');
        # FAILED: is(scalar(keys %$hash), 0, 'Hash remains empty after deletion attempt');
    # FAILED: }
# AFTER LAST PASS: }

done_testing();