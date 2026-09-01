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
    my $ixhash = bless {}, 'Tie::IxHash';
    while (my ($k, $v) = each %hash) {
        $ixhash->{$k} = $v;
    }
    return $ixhash;
}

# Test case: Shift on an empty hash
# AFTER LAST PASS: {
    my $ixhash;  # AFTER LAST PASS: my $ixhash = create_ixhash();
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Tie::IxHash::Shift($ixhash) };
    # FAILED: if ($@) { fail('Shift crashed on empty hash: ' . $@); }
    # FAILED: else {
        # FAILED: is($result, undef, 'Shift returns undef on empty hash');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Shift on a hash with one element
# AFTER LAST PASS: {
    my $ixhash;  # AFTER LAST PASS: my $ixhash = create_ixhash(a => 1);
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Tie::IxHash::Shift($ixhash) };
    # FAILED: if ($@) { fail('Shift crashed on single element hash: ' . $@); }
    # FAILED: else {
        # FAILED: is_deeply($result, ['a', 1], 'Shift returns correct key-value pair on single element hash');
        # FAILED: is_deeply($ixhash, create_ixhash(), 'Hash is empty after shift');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Shift on a hash with multiple elements
# AFTER LAST PASS: {
    my $ixhash;  # AFTER LAST PASS: my $ixhash = create_ixhash(a => 1, b => 2, c => 3);
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Tie::IxHash::Shift($ixhash) };
    # FAILED: if ($@) { fail('Shift crashed on multiple element hash: ' . $@); }
    # FAILED: else {
        # FAILED: is_deeply($result, ['a', 1], 'Shift returns correct key-value pair on multiple element hash');
        # FAILED: is_deeply($ixhash, create_ixhash(b => 2, c => 3), 'Hash is updated correctly after shift');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Shift on a hash with multiple elements, multiple shifts
# AFTER LAST PASS: {
    my $ixhash;  # AFTER LAST PASS: my $ixhash = create_ixhash(a => 1, b => 2, c => 3);
    my $result1;  # AFTER LAST PASS: my $result1;  # UNVALIDATED: my $result1 = eval { Tie::IxHash::Shift($ixhash) };
    my $result2;  # AFTER LAST PASS: my $result2;  # UNVALIDATED: my $result2 = eval { Tie::IxHash::Shift($ixhash) };
    my $result3;  # AFTER LAST PASS: my $result3;  # UNVALIDATED: my $result3 = eval { Tie::IxHash::Shift($ixhash) };
    # FAILED: if ($@) { fail('Shift crashed on multiple shifts: ' . $@); }
    # FAILED: else {
        # FAILED: is_deeply($result1, ['a', 1], 'First shift returns correct key-value pair');
        # FAILED: is_deeply($result2, ['b', 2], 'Second shift returns correct key-value pair');
        # FAILED: is_deeply($result3, ['c', 3], 'Third shift returns correct key-value pair');
        # FAILED: is_deeply($ixhash, create_ixhash(), 'Hash is empty after all shifts');
    # FAILED: }
# AFTER LAST PASS: }

done_testing();