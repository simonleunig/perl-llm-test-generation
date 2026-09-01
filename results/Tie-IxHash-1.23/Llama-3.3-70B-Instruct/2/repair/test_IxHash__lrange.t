use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::_lrange"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, '_lrange is defined'); }

my $result = eval { Tie::IxHash::_lrange( [], undef, 10 ) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, undef, 'Undefined offset returns undef'); }

my $array = [ [1, 2, 3, 4, 5] ];
my $offset = -3;
my $length = 2;
$result = eval { Tie::IxHash::_lrange($array, $offset, $length) };
if ($@) { fail('Function crashed: ' . $@); } else {
    my ($start, $end, $len) = @$result;
    is($start, 3, 'Negative offset start index');
    is($end, 4, 'Negative offset end index');
    is($len, 2, 'Negative offset length');
}

$offset = 10;
$length = 2;
$result = eval { Tie::IxHash::_lrange($array, $offset, $length) };
if ($@) { fail('Function crashed: ' . $@); } else {
    my ($start, $end, $len) = @$result;
    is($start, 5, 'Offset greater than size start index');
    is($end, 4, 'Offset greater than size end index');
    is($len, 0, 'Offset greater than size length');
}

$offset = 3;
$length = 10;
$result = eval { Tie::IxHash::_lrange($array, $offset, $length) };
if ($@) { fail('Function crashed: ' . $@); } else {
    my ($start, $end, $len) = @$result;
    is($start, 3, 'Length greater than remaining elements start index');
    is($end, 4, 'Length greater than remaining elements end index');
    is($len, 2, 'Length greater than remaining elements length');
}

$offset = 1;
$length = 3;
$result = eval { Tie::IxHash::_lrange($array, $offset, $length) };
if ($@) { fail('Function crashed: ' . $@); } else {
    my ($start, $end, $len) = @$result;
    is($start, 1, 'Valid offset and length start index');
    is($end, 3, 'Valid offset and length end index');
    is($len, 3, 'Valid offset and length length');
}

done_testing();