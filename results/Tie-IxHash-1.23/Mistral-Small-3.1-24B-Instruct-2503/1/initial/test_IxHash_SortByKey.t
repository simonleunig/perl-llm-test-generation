use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }  # Use actual module name from package declaration

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::SortByKey"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'SortByKey is defined'); }

# Mocking the Tie::IxHash methods
mock 'Tie::IxHash' => (
    Reorder => sub { return shift; },
    Keys    => sub { return keys %{shift->%*}; },
);

# Test case: Empty IxHash
my $empty_ixhash = bless {}, 'Tie::IxHash';
my $result = eval { Tie::IxHash::SortByKey($empty_ixhash) };
if ($@) { fail('Function crashed with empty IxHash: ' . $@); } else {
    is($result, $empty_ixhash, 'SortByKey returns the same object with empty IxHash');
}

# Test case: IxHash with single element
my $single_ixhash = bless { a => 1 }, 'Tie::IxHash';
$result = eval { Tie::IxHash::SortByKey($single_ixhash) };
if ($@) { fail('Function crashed with single element IxHash: ' . $@); } else {
    is($result, $single_ixhash, 'SortByKey returns the same object with single element IxHash');
    is_deeply([$single_ixhash->Keys], ['a'], 'Single element IxHash is correctly ordered');
}

# Test case: IxHash with multiple elements
my $multi_ixhash = bless { c => 3, a => 1, b => 2 }, 'Tie::IxHash';
$result = eval { Tie::IxHash::SortByKey($multi_ixhash) };
if ($@) { fail('Function crashed with multiple elements IxHash: ' . $@); } else {
    is($result, $multi_ixhash, 'SortByKey returns the same object with multiple elements IxHash');
    is_deeply([$multi_ixhash->Keys], ['a', 'b', 'c'], 'Multiple elements IxHash is correctly ordered');
}

# Test case: IxHash with duplicate keys (last key-value pair wins)
my $duplicate_ixhash = bless { a => 1, b => 2, a => 3 }, 'Tie::IxHash';
$result = eval { Tie::IxHash::SortByKey($duplicate_ixhash) };
if ($@) { fail('Function crashed with duplicate keys IxHash: ' . $@); } else {
    is($result, $duplicate_ixhash, 'SortByKey returns the same object with duplicate keys IxHash');
    is_deeply([$duplicate_ixhash->Keys], ['a', 'b'], 'Duplicate keys IxHash is correctly ordered');
}

done_testing();
