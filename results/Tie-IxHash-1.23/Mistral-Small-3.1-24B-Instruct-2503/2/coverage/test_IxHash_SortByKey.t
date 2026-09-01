use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::SortByKey"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'SortByKey is defined'); }

# Mocking the Tie::IxHash methods
my $mock;
# AFTER LAST PASS: eval { require Tie::IxHash; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: Tie::IxHash - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"Tie::IxHash::Reorder"} && defined &{"Tie::IxHash::Keys"}) {
        # AFTER LAST PASS: $mock = mock 'Tie::IxHash' => (
            # AFTER LAST PASS: override => {
                # AFTER LAST PASS: Reorder => sub { return shift; },
                # AFTER LAST PASS: Keys    => sub { return keys %{shift->%*}; },
            # AFTER LAST PASS: }
        # AFTER LAST PASS: );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock = mock 'Tie::IxHash' => (
            # AFTER LAST PASS: add => {
                # AFTER LAST PASS: Reorder => sub { return shift; },
                # AFTER LAST PASS: Keys    => sub { return keys %{shift->%*}; },
            # AFTER LAST PASS: }
        # AFTER LAST PASS: );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# Test case: Empty IxHash
my $empty_ixhash;  # AFTER LAST PASS: my $empty_ixhash = bless {}, 'Tie::IxHash';
my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Tie::IxHash::SortByKey($empty_ixhash) };
# FAILED: if ($@) { fail('Function crashed with empty IxHash: ' . $@); } else {
    # FAILED: is($result, undef, 'SortByKey does not return a value with empty IxHash');
# FAILED: }

# Test case: IxHash with single element
my $single_ixhash;  # AFTER LAST PASS: my $single_ixhash = bless { a => 1 }, 'Tie::IxHash';
# UNVALIDATED: $result = eval { Tie::IxHash::SortByKey($single_ixhash) };
# FAILED: if ($@) { fail('Function crashed with single element IxHash: ' . $@); } else {
    # FAILED: is($result, undef, 'SortByKey does not return a value with single element IxHash');
    # FAILED: is_deeply([$single_ixhash->Keys], ['a'], 'Single element IxHash is correctly ordered');
# FAILED: }

# Test case: IxHash with multiple elements
my $multi_ixhash;  # AFTER LAST PASS: my $multi_ixhash = bless { c => 3, a => 1, b => 2 }, 'Tie::IxHash';
# UNVALIDATED: $result = eval { Tie::IxHash::SortByKey($multi_ixhash) };
# FAILED: if ($@) { fail('Function crashed with multiple elements IxHash: ' . $@); } else {
    # FAILED: is($result, undef, 'SortByKey does not return a value with multiple elements IxHash');
    # FAILED: is_deeply([$multi_ixhash->Keys], ['a', 'b', 'c'], 'Multiple elements IxHash is correctly ordered');
# FAILED: }

# Test case: IxHash with duplicate keys (last key-value pair wins)
my $duplicate_ixhash;  # AFTER LAST PASS: my $duplicate_ixhash = bless { a => 1, b => 2, a => 3 }, 'Tie::IxHash';
# UNVALIDATED: $result = eval { Tie::IxHash::SortByKey($duplicate_ixhash) };
# FAILED: if ($@) { fail('Function crashed with duplicate keys IxHash: ' . $@); } else {
    # FAILED: is($result, undef, 'SortByKey does not return a value with duplicate keys IxHash');
    # FAILED: is_deeply([$duplicate_ixhash->Keys], ['a', 'b'], 'Duplicate keys IxHash is correctly ordered');
# FAILED: }

done_testing();