use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }  # Use actual module name from package declaration

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
{
    my $hash = mock_tie_ixhash();
    my $result = eval { Tie::IxHash::NEXTKEY($hash) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 'a', 'NEXTKEY returns the first key');
        $hash->{index}++;
        $result = eval { Tie::IxHash::NEXTKEY($hash) };
        if ($@) { fail('Function crashed: ' . $@); } else {
            is($result, 'b', 'NEXTKEY returns the second key');
            $hash->{index}++;
            $result = eval { Tie::IxHash::NEXTKEY($hash) };
            if ($@) { fail('Function crashed: ' . $@); } else {
                is($result, 'c', 'NEXTKEY returns the third key');
                $hash->{index}++;
                $result = eval { Tie::IxHash::NEXTKEY($hash) };
                if ($@) { fail('Function crashed: ' . $@); } else {
                    is($result, undef, 'NEXTKEY returns undef after all keys are iterated');
                }
            }
        }
    }
}

# Test case 2: Edge case with empty hash
{
    my $hash = mock_tie_ixhash();
    $hash->{keys} = [];
    $hash->{values} = [];
    $hash->{index} = 0;
    my $result = eval { Tie::IxHash::NEXTKEY($hash) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, undef, 'NEXTKEY returns undef for an empty hash');
    }
}

# Test case 3: Edge case with index exceeding the number of keys
{
    my $hash = mock_tie_ixhash();
    $hash->{index} = 3;
    my $result = eval { Tie::IxHash::NEXTKEY($hash) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, undef, 'NEXTKEY returns undef when index exceeds the number of keys');
    }
}

done_testing();
