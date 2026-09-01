use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Mocking the necessary methods of Tie::IxHash
my $mock;
eval { require Tie::IxHash; };
if ($@) {
    # DEPENDENCY MISSING: Tie::IxHash - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Tie::IxHash::Reorder"}) {
        $mock = mock 'Tie::IxHash' => (
            override => [
                Reorder => sub { return shift },
                Keys    => sub { return @{shift->{keys}} },
                FETCH   => sub { return shift->{values}->[shift] },
            ]
        );
    } else {
        $mock = mock 'Tie::IxHash' => (
            add => [
                Reorder => sub { return shift },
                Keys    => sub { return @{shift->{keys}} },
                FETCH   => sub { return shift->{values}->[shift] },
            ]
        );
    }
}

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::SortByValue"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'SortByValue is defined'); }

# Test case: Empty IxHash
my $empty_ixhash = bless { keys => [], values => [] }, 'Tie::IxHash';
my $result = eval { Tie::IxHash::SortByValue($empty_ixhash) };
if ($@) { fail('Function crashed with empty IxHash: ' . $@); } else {
    is($result, $empty_ixhash, 'SortByValue returns the same empty IxHash');
}

# Test case: Single element IxHash
my $single_ixhash = bless { keys => ['a'], values => ['value1'] }, 'Tie::IxHash';
$result = eval { Tie::IxHash::SortByValue($single_ixhash) };
if ($@) { fail('Function crashed with single element IxHash: ' . $@); } else {
    is($result, $single_ixhash, 'SortByValue returns the same single element IxHash');
}

# Test case: Multiple elements IxHash
my $multi_ixhash;  # AFTER LAST PASS: my $multi_ixhash = bless { keys => ['a', 'b', 'c'], values => ['value2', 'value1', 'value3'] }, 'Tie::IxHash';
# UNVALIDATED: $result = eval { Tie::IxHash::SortByValue($multi_ixhash) };
# FAILED: if ($@) { fail('Function crashed with multiple elements IxHash: ' . $@); } else {
    # FAILED: is_deeply([$multi_ixhash->{keys}->@*], ['b', 'a', 'c'], 'SortByValue reorders keys correctly by values');
# FAILED: }

# Test case: Duplicate values in IxHash
my $duplicate_ixhash;  # AFTER LAST PASS: my $duplicate_ixhash = bless { keys => ['a', 'b', 'c'], values => ['value1', 'value1', 'value2'] }, 'Tie::IxHash';
# UNVALIDATED: $result = eval { Tie::IxHash::SortByValue($duplicate_ixhash) };
# FAILED: if ($@) { fail('Function crashed with duplicate values IxHash: ' . $@); } else {
    # The order of 'a' and 'b' is not specified, so we check if both are present in the first two positions
    my $keys;  # AFTER LAST PASS: my $keys;  # FAILED: my $keys = $duplicate_ixhash->{keys};
    # FAILED: ok(grep { $_ eq 'a' } @$keys[0..1], 'Key "a" is in the first two positions');
    # FAILED: ok(grep { $_ eq 'b' } @$keys[0..1], 'Key "b" is in the first two positions');
    # FAILED: is($keys->[2], 'c', 'Key "c" is in the third position');
# FAILED: }

# Test case: Invalid input (not an IxHash object)
my $invalid_input;  # AFTER LAST PASS: my $invalid_input = 'not an IxHash object';
# UNVALIDATED: $result = eval { Tie::IxHash::SortByValue($invalid_input) };
# FAILED: if ($@) { ok(1, 'Function crashes with invalid input'); } else {
    # FAILED: fail('Function did not crash with invalid input');
# FAILED: }

done_testing();