use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::numeric_escape"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'numeric_escape is defined'); }

# Test case 1: Test with default options
my $simple = bless {}, 'XML::Simple';
$simple->{opt} = { numericescape => '1' };
my $result = eval { $simple->numeric_escape('Hello, world!', 1) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result with default options'); }
is($result, 'Hello, world!', 'Result matches expected output with default options');

# Test case 2: Test with numericescape option set to 2
$simple->{opt} = { numericescape => '2' };
$result = eval { $simple->numeric_escape('Hello, world!', 1) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result with numericescape option set to 2'); }
is($result, 'Hello, world!', 'Result matches expected output with numericescape option set to 2');

# Test case 3: Test with non-ASCII characters
$simple->{opt} = { numericescape => '1' };
$result = eval { $simple->numeric_escape('Hëllo, world!', 1) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result with non-ASCII characters'); }
is($result, 'H&#235;llo, world!', 'Result matches expected output with non-ASCII characters');

# Test case 4: Test with undefined input
$result = eval { $simple->numeric_escape(undef, 1) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result with undefined input'); }
is($result, '', 'Result matches expected output with undefined input');

# Test case 5: Test with invalid level
$result = eval { $simple->numeric_escape('Hello, world!', 'invalid') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result with invalid level'); }
is($result, 'Hello, world!', 'Result matches expected output with invalid level');

done_testing();
