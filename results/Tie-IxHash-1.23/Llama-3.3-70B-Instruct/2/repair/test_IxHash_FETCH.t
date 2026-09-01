use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::FETCH"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'FETCH is defined'); }

# Test case 1: Existing key
my $tie = tie my %hash, 'Tie::IxHash';
$hash{key} = 'value';
my $result = eval { Tie::IxHash::FETCH($tie, 'key') };
if ($@) { fail('FETCH crashed: ' . $@); } else { is($result, 'value', 'FETCH returns value for existing key'); }

# Test case 2: Non-existing key
$result = eval { Tie::IxHash::FETCH($tie, 'non-existing') };
if ($@) { fail('FETCH crashed: ' . $@); } else { is($result, undef, 'FETCH returns undef for non-existing key'); }

# Test case 3: Empty hash
untie %hash;
$tie = tie %hash, 'Tie::IxHash';
$result = eval { Tie::IxHash::FETCH($tie, 'key') };
if ($@) { fail('FETCH crashed: ' . $@); } else { is($result, undef, 'FETCH returns undef for empty hash'); }

done_testing();
