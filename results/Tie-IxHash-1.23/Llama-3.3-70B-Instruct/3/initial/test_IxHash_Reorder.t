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
if ($@) { fail('Reorder crashed: ' . $@); } else { ok(defined $result, 'Reorder returns result with empty input'); }

# Test case 2: Input list with existing keys
my $tie2 = tie my %hash2, 'Tie::IxHash';
$hash2{a} = 1;
$hash2{b} = 2;
$hash2{c} = 3;
my $result2 = eval { Tie::IxHash::Reorder($tie2, 'c', 'a', 'b') };
if ($@) { fail('Reorder crashed: ' . $@); } else { ok(defined $result2, 'Reorder returns result with existing keys'); }
is_deeply($tie2->[1], ['c', 'a', 'b'], 'Reorder reorders keys correctly');
is_deeply($tie2->[2], [3, 1, 2], 'Reorder reorders values correctly');

# Test case 3: Input list with non-existing keys
my $tie3 = tie my %hash3, 'Tie::IxHash';
$hash3{a} = 1;
$hash3{b} = 2;
$hash3{c} = 3;
my $result3 = eval { Tie::IxHash::Reorder($tie3, 'c', 'd', 'b') };
if ($@) { fail('Reorder crashed: ' . $@); } else { ok(defined $result3, 'Reorder returns result with non-existing keys'); }
is_deeply($tie3->[1], ['c', 'b'], 'Reorder ignores non-existing keys');
is_deeply($tie3->[2], [3, 2], 'Reorder reorders values correctly');

# Test case 4: Input list with duplicate keys
my $tie4 = tie my %hash4, 'Tie::IxHash';
$hash4{a} = 1;
$hash4{b} = 2;
$hash4{c} = 3;
my $result4 = eval { Tie::IxHash::Reorder($tie4, 'c', 'a', 'a', 'b') };
if ($@) { fail('Reorder crashed: ' . $@); } else { ok(defined $result4, 'Reorder returns result with duplicate keys'); }
is_deeply($tie4->[1], ['c', 'a', 'b'], 'Reorder reorders keys correctly');
is_deeply($tie4->[2], [3, 1, 2], 'Reorder reorders values correctly');

done_testing();
