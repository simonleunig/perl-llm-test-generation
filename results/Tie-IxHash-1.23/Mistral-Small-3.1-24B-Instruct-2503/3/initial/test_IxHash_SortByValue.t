use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }  # Use actual module name from package declaration

# Mocking the necessary methods of Tie::IxHash
mock 'Tie::IxHash' => (
    Reorder => sub { return shift },
    Keys    => sub { return @{shift->{keys}} },
    FETCH   => sub { return shift->{values}->[shift] },
);

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
my $multi_ixhash = bless { keys => ['a', 'b', 'c'], values => ['value2', 'value1', 'value3'] }, 'Tie::IxHash';
$result = eval { Tie::IxHash::SortByValue($multi_ixhash) };
if ($@) { fail('Function crashed with multiple elements IxHash: ' . $@); } else {
    is_deeply([$multi_ixhash->{keys}->@*], ['b', 'a', 'c'], 'SortByValue reorders keys correctly by values');
}

# Test case: Duplicate values in IxHash
my $duplicate_ixhash = bless { keys => ['a', 'b', 'c'], values => ['value1', 'value1', 'value2'] }, 'Tie::IxHash';
$result = eval { Tie::IxHash::SortByValue($duplicate_ixhash) };
if ($@) { fail('Function crashed with duplicate values IxHash: ' . $@); } else {
    # The order of 'a' and 'b' is not specified, so we check if both are present in the first two positions
    my $keys = $multi_ixhash->{keys};
    ok(grep { $_ eq 'a' } @$keys[0..1], 'Key "a" is in the first two positions');
    ok(grep { $_ eq 'b' } @$keys[0..1], 'Key "b" is in the first two positions');
    is($keys->[2], 'c', 'Key "c" is in the third position');
}

# Test case: Invalid input (not an IxHash object)
$result = eval { Tie::IxHash::SortByValue({}) };
if ($@) { pass('Function correctly fails with invalid input'); } else {
    fail('Function did not fail with invalid input');
}

done_testing();
