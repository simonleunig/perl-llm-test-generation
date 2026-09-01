use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::FIRSTKEY"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'FIRSTKEY is defined'); }

# Test case: Empty hash
my $tie = tie my %hash, 'Tie::IxHash';
my $result = eval { Tie::IxHash::FIRSTKEY($tie) };
if ($@) { fail('FIRSTKEY crashed on empty hash: ' . $@); } else { is($result, undef, 'FIRSTKEY returns undef on empty hash'); }

# Test case: Hash with elements
%hash = (a => 1, b => 2);
$result = eval { Tie::IxHash::FIRSTKEY($tie) };
if ($@) { fail('FIRSTKEY crashed on non-empty hash: ' . $@); } else { is($result, 'a', 'FIRSTKEY returns first key on non-empty hash'); }

# Test case: Hash with multiple elements
%hash = (a => 1, b => 2, c => 3);
$result = eval { Tie::IxHash::FIRSTKEY($tie) };
if ($@) { fail('FIRSTKEY crashed on hash with multiple elements: ' . $@); } else { is($result, 'a', 'FIRSTKEY returns first key on hash with multiple elements'); }

done_testing();
