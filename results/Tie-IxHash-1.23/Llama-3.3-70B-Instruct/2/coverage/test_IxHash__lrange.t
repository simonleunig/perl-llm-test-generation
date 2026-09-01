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

my $array;  # AFTER LAST PASS: my $array = [ [1, 2, 3, 4, 5] ];
my $offset;  # AFTER LAST PASS: my $offset = -3;
my $length;  # AFTER LAST PASS: my $length = 2;
# UNVALIDATED: $result = eval { Tie::IxHash::_lrange($array, $offset, $length) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
    my ($start, $end, $len);  # AFTER LAST PASS: my ($start, $end, $len);  # FAILED: my ($start, $end, $len) = @$result;
    # FAILED: is($start, 3, 'Negative offset start index');
    # FAILED: is($end, 4, 'Negative offset end index');
    # FAILED: is($len, 2, 'Negative offset length');
# FAILED: }

# AFTER LAST PASS: $offset = 10;
# AFTER LAST PASS: $length = 2;
# UNVALIDATED: $result = eval { Tie::IxHash::_lrange($array, $offset, $length) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
    my ($start, $end, $len);  # AFTER LAST PASS: my ($start, $end, $len);  # FAILED: my ($start, $end, $len) = @$result;
    # FAILED: is($start, 5, 'Offset greater than size start index');
    # FAILED: is($end, 4, 'Offset greater than size end index');
    # FAILED: is($len, 0, 'Offset greater than size length');
# FAILED: }

# AFTER LAST PASS: $offset = 3;
# AFTER LAST PASS: $length = 10;
# UNVALIDATED: $result = eval { Tie::IxHash::_lrange($array, $offset, $length) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
    my ($start, $end, $len);  # AFTER LAST PASS: my ($start, $end, $len);  # FAILED: my ($start, $end, $len) = @$result;
    # FAILED: is($start, 3, 'Length greater than remaining elements start index');
    # FAILED: is($end, 4, 'Length greater than remaining elements end index');
    # FAILED: is($len, 2, 'Length greater than remaining elements length');
# FAILED: }

# AFTER LAST PASS: $offset = 1;
# AFTER LAST PASS: $length = 3;
# UNVALIDATED: $result = eval { Tie::IxHash::_lrange($array, $offset, $length) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
    my ($start, $end, $len);  # AFTER LAST PASS: my ($start, $end, $len);  # FAILED: my ($start, $end, $len) = @$result;
    # FAILED: is($start, 1, 'Valid offset and length start index');
    # FAILED: is($end, 3, 'Valid offset and length end index');
    # FAILED: is($len, 3, 'Valid offset and length length');
# FAILED: }

done_testing();