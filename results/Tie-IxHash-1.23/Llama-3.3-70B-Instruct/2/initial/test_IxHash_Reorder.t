use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::Reorder"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'Reorder is defined'); }

# Test case 1: Empty input list
my $tie = tie my %hash, 'Tie::IxHash';
$hash{a} = 1;
$hash{b} = 2;
$hash{c} = 3;
my $result = eval { Tie::IxHash::Reorder($tie) };
if ($@) { fail('Reorder crashed with empty input: ' . $@); } else { ok(defined $result, 'Reorder returns result with empty input'); }

# Test case 2: Input list with existing keys
$result = eval { Tie::IxHash::Reorder($tie, 'b', 'a', 'c') };
if ($@) { fail('Reorder crashed with existing keys: ' . $@); } else { ok(defined $result, 'Reorder returns result with existing keys'); }
is_deeply($result->[1], ['b', 'a', 'c'], 'Reorder correct order with existing keys');
is_deeply($result->[2], [2, 1, 3], 'Reorder correct values with existing keys');

# Test case 3: Input list with non-existing keys
$result = eval { Tie::IxHash::Reorder($tie, 'b', 'd', 'c') };
if ($@) { fail('Reorder crashed with non-existing keys: ' . $@); } else { ok(defined $result, 'Reorder returns result with non-existing keys'); }
is_deeply($result->[1], ['b', 'c'], 'Reorder correct order with non-existing keys');
is_deeply($result->[2], [2, 3], 'Reorder correct values with non-existing keys');

# Test case 4: Input list with duplicate keys
$result = eval { Tie::IxHash::Reorder($tie, 'b', 'b', 'c') };
if ($@) { fail('Reorder crashed with duplicate keys: ' . $@); } else { ok(defined $result, 'Reorder returns result with duplicate keys'); }
is_deeply($result->[1], ['b', 'c'], 'Reorder correct order with duplicate keys');
is_deeply($result->[2], [2, 3], 'Reorder correct values with duplicate keys');

done_testing();
