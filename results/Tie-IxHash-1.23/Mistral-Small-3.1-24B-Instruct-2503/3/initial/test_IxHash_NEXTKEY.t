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
    my $keys = shift;
    my $values = shift;
    my $index = 0;
    return bless [ $keys, $values, $index ], 'Tie::IxHash';
}

# Test case 1: Normal operation with keys
{
    my $keys = [qw(a b c)];
    my $values = [1, 2, 3];
    my $hash = mock_tie_ixhash($keys, $values);

    my $result = eval { Tie::IxHash::NEXTKEY($hash) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 'a', 'NEXTKEY returns the first key');
        $hash->[2]++;  # Manually increment the index for the next test
        $result = eval { Tie::IxHash::NEXTKEY($hash) };
        if ($@) { fail('Function crashed: ' . $@); } else {
            is($result, 'b', 'NEXTKEY returns the second key');
            $hash->[2]++;  # Manually increment the index for the next test
            $result = eval { Tie::IxHash::NEXTKEY($hash) };
            if ($@) { fail('Function crashed: ' . $@); } else {
                is($result, 'c', 'NEXTKEY returns the third key');
                $hash->[2]++;  # Manually increment the index for the next test
                $result = eval { Tie::IxHash::NEXTKEY($hash) };
                if ($@) { fail('Function crashed: ' . $@); } else {
                    is($result, undef, 'NEXTKEY returns undef after all keys are iterated');
                }
            }
        }
    }
}

# Test case 2: Empty hash
{
    my $keys = [];
    my $values = [];
    my $hash = mock_tie_ixhash($keys, $values);

    my $result = eval { Tie::IxHash::NEXTKEY($hash) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, undef, 'NEXTKEY returns undef for an empty hash');
    }
}

# Test case 3: Single key in hash
{
    my $keys = ['a'];
    my $values = [1];
    my $hash = mock_tie_ixhash($keys, $values);

    my $result = eval { Tie::IxHash::NEXTKEY($hash) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 'a', 'NEXTKEY returns the single key');
        $hash->[2]++;  # Manually increment the index for the next test
        $result = eval { Tie::IxHash::NEXTKEY($hash) };
        if ($@) { fail('Function crashed: ' . $@); } else {
            is($result, undef, 'NEXTKEY returns undef after the single key is iterated');
        }
    }
}

done_testing();
