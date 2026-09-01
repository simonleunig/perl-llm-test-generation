use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::Pop2"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'Pop2 is defined'); }

my $ixhash = tie my %hash, 'Tie::IxHash';

my $result = eval { $ixhash->Pop2() };
if ($@) { fail('Pop2 crashed: ' . $@); } else { is($result, undef, 'Pop2 from empty hash returns undef'); }

%hash = (a => 1, b => 2, c => 3);
$result = eval { $ixhash->Pop2() };
if ($@) { fail('Pop2 crashed: ' . $@); } else { is_deeply($result, ['c', 3], 'Pop2 from non-empty hash returns last key-value pair'); }

%hash = (a => 1);
$result = eval { $ixhash->Pop2() };
if ($@) { fail('Pop2 crashed: ' . $@); } else { is_deeply($result, ['a', 1], 'Pop2 from hash with single element returns that element'); }

done_testing();