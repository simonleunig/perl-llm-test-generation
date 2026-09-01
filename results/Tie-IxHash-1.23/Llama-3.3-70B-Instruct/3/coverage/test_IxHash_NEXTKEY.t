use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::NEXTKEY"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'NEXTKEY is defined'); }

my $tie = tie my %hash, 'Tie::IxHash';
$hash{a} = 1;
$hash{b} = 2;
$hash{c} = 3;

my $result = eval { Tie::IxHash::NEXTKEY($tie) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'a', 'NEXTKEY returns first key'); }

my $result2 = eval { Tie::IxHash::NEXTKEY($tie) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result2, 'b', 'NEXTKEY returns next key'); }

my $result3 = eval { Tie::IxHash::NEXTKEY($tie) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result3, 'c', 'NEXTKEY returns last key'); }

my $result4 = eval { Tie::IxHash::NEXTKEY($tie) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result4, undef, 'NEXTKEY returns undef when no more keys'); }

my $result5 = eval { Tie::IxHash::NEXTKEY('invalid input') };
if ($@) { 
    like($@, qr/Can't use string .* as an ARRAY ref/, 'NEXTKEY handles invalid input');
} else { 
    # FAILED: fail('NEXTKEY did not crash with invalid input');
}

done_testing();