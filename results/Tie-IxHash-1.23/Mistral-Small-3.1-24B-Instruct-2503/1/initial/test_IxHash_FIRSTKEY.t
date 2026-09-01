use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }  # Use actual module name from package declaration

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::FIRSTKEY"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'FIRSTKEY is defined'); }

# Mocking the NEXTKEY function since it's a dependency
mock 'Tie::IxHash', 'NEXTKEY' => sub {
    my $self = shift;
    return $self->[0][$self->[3]++];
};

# Test case: Hash with elements
{
    my $hash = bless [], 'Tie::IxHash';
    $hash->[0] = [qw(a b c)];
    $hash->[3] = 0;  # Reset the iteration index

    my $result = eval { Tie::IxHash::FIRSTKEY($hash) };
    if ($@) { fail('FIRSTKEY crashed: ' . $@); } else {
        is($result, 'a', 'FIRSTKEY returns the first key in a non-empty hash');
    }
}

# Test case: Empty hash
{
    my $hash = bless [], 'Tie::IxHash';
    $hash->[0] = [];
    $hash->[3] = 0;  # Reset the iteration index

    my $result = eval { Tie::IxHash::FIRSTKEY($hash) };
    if ($@) { fail('FIRSTKEY crashed: ' . $@); } else {
        is($result, undef, 'FIRSTKEY returns undef for an empty hash');
    }
}

# Test case: Hash with one element
{
    my $hash = bless [], 'Tie::IxHash';
    $hash->[0] = ['single'];
    $hash->[3] = 0;  # Reset the iteration index

    my $result = eval { Tie::IxHash::FIRSTKEY($hash) };
    if ($@) { fail('FIRSTKEY crashed: ' . $@); } else {
        is($result, 'single', 'FIRSTKEY returns the single key in a one-element hash');
    }
}

done_testing();
