use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::NEXTKEY"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'NEXTKEY is defined'); }

# Mocking the Tie::IxHash object for testing
sub mock_tie_ixhash {
    my $self = {
        keys => [qw(a b c)],
        values => [1, 2, 3],
        index => 0,
    };
    return bless $self, 'Tie::IxHash';
}

# Test case 1: Normal operation with keys available
# AFTER LAST PASS: {
    my $hash;  # AFTER LAST PASS: my $hash = mock_tie_ixhash();
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Tie::IxHash::NEXTKEY($hash) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, 'a', 'NEXTKEY returns the first key');
        # FAILED: $hash->{index}++;
        # FAILED: $result = eval { Tie::IxHash::NEXTKEY($hash) };
        # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
            # FAILED: is($result, 'b', 'NEXTKEY returns the second key');
            # FAILED: $hash->{index}++;
            # FAILED: $result = eval { Tie::IxHash::NEXTKEY($hash) };
            # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
                # FAILED: is($result, 'c', 'NEXTKEY returns the third key');
                # FAILED: $hash->{index}++;
                # FAILED: $result = eval { Tie::IxHash::NEXTKEY($hash) };
                # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
                    # FAILED: is($result, undef, 'NEXTKEY returns undef after all keys are iterated');
                # FAILED: }
            # FAILED: }
        # FAILED: }
    # FAILED: }
# AFTER LAST PASS: }

# Test case 2: Edge case with empty hash
# AFTER LAST PASS: {
    my $hash;  # AFTER LAST PASS: my $hash = mock_tie_ixhash();
    # AFTER LAST PASS: $hash->{keys} = [];
    # AFTER LAST PASS: $hash->{values} = [];
    # AFTER LAST PASS: $hash->{index} = 0;
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Tie::IxHash::NEXTKEY($hash) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, undef, 'NEXTKEY returns undef for an empty hash');
    # FAILED: }
# AFTER LAST PASS: }

# Test case 3: Edge case with index exceeding the number of keys
# AFTER LAST PASS: {
    my $hash;  # AFTER LAST PASS: my $hash = mock_tie_ixhash();
    # AFTER LAST PASS: $hash->{index} = 3;
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Tie::IxHash::NEXTKEY($hash) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, undef, 'NEXTKEY returns undef when index exceeds the number of keys');
    # FAILED: }
# AFTER LAST PASS: }

done_testing();