use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::DELETE"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'DELETE is defined'); }

my $ixhash = tie my %hash, 'Tie::IxHash';
$hash{a} = 1;
$hash{b} = 2;
my $result = eval { Tie::IxHash::DELETE($ixhash, 'a') };
if ($@) { fail('DELETE crashed: ' . $@); } else { is($result, 1, 'DELETE returns value of deleted element'); }

$result = eval { Tie::IxHash::DELETE($ixhash, 'c') };
if ($@) { fail('DELETE crashed: ' . $@); } else { is($result, undef, 'DELETE returns undef for non-existent key'); }

$hash{c} = 3;
$result = eval { Tie::IxHash::DELETE($ixhash, 'c') };
if ($@) { fail('DELETE crashed: ' . $@); } else { is($result, 3, 'DELETE returns value of last element'); }

%hash = ();
my $new_ixhash = tie %hash, 'Tie::IxHash';
$hash{a} = 1;
$result = eval { Tie::IxHash::DELETE($new_ixhash, 'a') };
if ($@) { fail('DELETE crashed: ' . $@); } else { is($result, 1, 'DELETE returns value of only element'); }

done_testing();