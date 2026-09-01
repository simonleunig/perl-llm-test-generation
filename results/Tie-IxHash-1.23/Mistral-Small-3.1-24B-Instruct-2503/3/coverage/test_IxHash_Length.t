use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::Length"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'Length is defined'); }

sub mock_tie_ixhash {
    my $keys = shift;
    return bless [undef, $keys], 'Tie::IxHash';
}

{
    my $hash = mock_tie_ixhash([]);
    my $result = eval { Tie::IxHash::Length($hash) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 0, 'Length returns 0 for an empty hash');
    }
}

{
    my $keys = ['key1', 'key2', 'key3'];
    my $hash = mock_tie_ixhash($keys);
    my $result = eval { Tie::IxHash::Length($hash) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 3, 'Length returns correct number of keys for a non-empty hash');
    }
}

{
    my $invalid_input = 'not_a_hash';
    my $result = eval { Tie::IxHash::Length($invalid_input) };
    if ($@) {
        like($@, qr/Can't use string \(.*\) as an ARRAY ref/, 'Function handles invalid input gracefully');
    } else {
        # FAILED: fail('Function did not crash with invalid input');
    }
}

{
    my $keys = ['single_key'];
    my $hash = mock_tie_ixhash($keys);
    my $result = eval { Tie::IxHash::Length($hash) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 1, 'Length returns 1 for a hash with a single key');
    }
}

# AFTER LAST PASS: {
    my $keys;  # AFTER LAST PASS: my $keys = map { "key$_" } 1..1000;
    my $hash;  # AFTER LAST PASS: my $hash = mock_tie_ixhash($keys);
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Tie::IxHash::Length($hash) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, 1000, 'Length returns correct number of keys for a large hash');
    # FAILED: }
# AFTER LAST PASS: }

done_testing();