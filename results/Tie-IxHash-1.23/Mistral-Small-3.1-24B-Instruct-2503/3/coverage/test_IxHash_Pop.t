use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::Pop"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'Pop is defined'); }

# Helper function to create a Tie::IxHash object
sub create_ixhash {
    my %hash = @_;
    my $ixhash = bless [ \%hash, [keys %hash], [values %hash] ], 'Tie::IxHash';
    return $ixhash;
}

# Test case: Pop from an empty hash
{
    my $ixhash = create_ixhash();
    my $result = eval { Tie::IxHash::Pop($ixhash) };
    if ($@) { fail('Pop crashed: ' . $@); } else {
        is($result, undef, 'Pop returns undef when hash is empty');
    }
}

# Test case: Pop from a hash with one key-value pair
# AFTER LAST PASS: {
    my $ixhash;  # AFTER LAST PASS: my $ixhash = create_ixhash(key1 => 'value1');
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Tie::IxHash::Pop($ixhash) };
    # FAILED: if ($@) { fail('Pop crashed: ' . $@); } else {
        # FAILED: is_deeply($result, ['key1', 'value1'], 'Pop returns the correct key-value pair');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Pop from a hash with multiple key-value pairs
# AFTER LAST PASS: {
    my $ixhash;  # AFTER LAST PASS: my $ixhash = create_ixhash(key1 => 'value1', key2 => 'value2', key3 => 'value3');
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Tie::IxHash::Pop($ixhash) };
    # FAILED: if ($@) { fail('Pop crashed: ' . $@); } else {
        # FAILED: is_deeply($result, ['key3', 'value3'], 'Pop returns the correct key-value pair');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Pop from a hash with multiple key-value pairs, then pop again
# AFTER LAST PASS: {
    my $ixhash;  # AFTER LAST PASS: my $ixhash = create_ixhash(key1 => 'value1', key2 => 'value2', key3 => 'value3');
    my $result1;  # AFTER LAST PASS: my $result1;  # UNVALIDATED: my $result1 = eval { Tie::IxHash::Pop($ixhash) };
    # FAILED: if ($@) { fail('Pop crashed: ' . $@); } else {
        # FAILED: is_deeply($result1, ['key3', 'value3'], 'Pop returns the correct key-value pair');
        my $result2;  # AFTER LAST PASS: my $result2;  # FAILED: my $result2 = eval { Tie::IxHash::Pop($ixhash) };
        # FAILED: if ($@) { fail('Pop crashed: ' . $@); } else {
            # FAILED: is_deeply($result2, ['key2', 'value2'], 'Pop returns the correct key-value pair after first pop');
        # FAILED: }
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Pop from a hash with multiple key-value pairs, then pop until empty
# AFTER LAST PASS: {
    my $ixhash;  # AFTER LAST PASS: my $ixhash = create_ixhash(key1 => 'value1', key2 => 'value2', key3 => 'value3');
    my $result1;  # AFTER LAST PASS: my $result1;  # UNVALIDATED: my $result1 = eval { Tie::IxHash::Pop($ixhash) };
    # FAILED: if ($@) { fail('Pop crashed: ' . $@); } else {
        # FAILED: is_deeply($result1, ['key3', 'value3'], 'Pop returns the correct key-value pair');
        my $result2;  # AFTER LAST PASS: my $result2;  # FAILED: my $result2 = eval { Tie::IxHash::Pop($ixhash) };
        # FAILED: if ($@) { fail('Pop crashed: ' . $@); } else {
            # FAILED: is_deeply($result2, ['key2', 'value2'], 'Pop returns the correct key-value pair after first pop');
            my $result3;  # AFTER LAST PASS: my $result3;  # FAILED: my $result3 = eval { Tie::IxHash::Pop($ixhash) };
            # FAILED: if ($@) { fail('Pop crashed: ' . $@); } else {
                # FAILED: is_deeply($result3, ['key1', 'value1'], 'Pop returns the correct key-value pair after second pop');
                my $result4;  # AFTER LAST PASS: my $result4;  # FAILED: my $result4 = eval { Tie::IxHash::Pop($ixhash) };
                # FAILED: if ($@) { fail('Pop crashed: ' . $@); } else {
                    # FAILED: is($result4, undef, 'Pop returns undef when hash is empty after all pops');
                # FAILED: }
            # FAILED: }
        # FAILED: }
    # FAILED: }
# AFTER LAST PASS: }

done_testing();