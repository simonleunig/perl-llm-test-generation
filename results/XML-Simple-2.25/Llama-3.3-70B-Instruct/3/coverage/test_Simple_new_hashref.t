use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::new_hashref"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'new_hashref is defined'); }

my $result = eval { XML::Simple->new_hashref() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result with no arguments'); }
is(ref($result), 'HASH', 'Result is a hash reference with no arguments');

$result = eval { XML::Simple->new_hashref(a => 1, b => 2) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result with arguments'); }
is(ref($result), 'HASH', 'Result is a hash reference with arguments');
is($result->{a}, 1, 'Result hash key a is correct with arguments');
is($result->{b}, 2, 'Result hash key b is correct with arguments');

done_testing();