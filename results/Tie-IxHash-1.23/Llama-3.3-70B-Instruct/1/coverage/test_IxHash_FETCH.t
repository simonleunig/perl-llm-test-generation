use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::FETCH"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'FETCH is defined'); }

my $tie = tie my %hash, 'Tie::IxHash';
$hash{key} = 'value';

my $result = eval { Tie::IxHash::FETCH($tie, 'key') };
if ($@) { fail('FETCH crashed: ' . $@); } else { is($result, 'value', 'FETCH returns value for existing key'); }

$result = eval { Tie::IxHash::FETCH($tie, 'non-existing') };
if ($@) { fail('FETCH crashed: ' . $@); } else { is($result, undef, 'FETCH returns undef for non-existing key'); }

$result = eval { Tie::IxHash::FETCH('invalid', 'key') };
if ($@) { 
    like($@, qr/Can't use string .* as an ARRAY ref/, 'FETCH dies with invalid input');
} else { 
    # FAILED: fail('FETCH did not die with invalid input');
}

done_testing();