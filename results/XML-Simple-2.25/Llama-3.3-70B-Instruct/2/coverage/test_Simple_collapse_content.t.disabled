use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::collapse_content"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'collapse_content is defined'); }

# Test case 1: Normal successful operation
my $simple = bless { opt => { contentkey => 'content' } }, 'XML::Simple';
my $hashref = { key1 => { content => 'value1' } };
my $result = eval { $simple->collapse_content($hashref) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }
is($result->{key1}, 'value1', 'collapse_content collapses nested elements correctly');

# Test case 2: Edge case - input hash reference has multiple key-value pairs
$hashref = { key1 => { content => 'value1' }, key2 => { content => 'value2' } };
$result = eval { $simple->collapse_content($hashref) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }
use Test2::V0 qw/is_deeply/;
is_deeply($result, $hashref, 'collapse_content returns original hash reference when input has multiple key-value pairs');

# Test case 3: Edge case - value is not a hash reference
$hashref = { key1 => 'value1' };
$result = eval { $simple->collapse_content($hashref) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }
is_deeply($result, $hashref, 'collapse_content returns original hash reference when value is not a hash reference');

# Test case 4: Edge case - hash reference value has multiple key-value pairs
$hashref = { key1 => { content => 'value1', extra => 'extra' } };
$result = eval { $simple->collapse_content($hashref) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }
is_deeply($result, $hashref, 'collapse_content returns original hash reference when hash reference value has multiple key-value pairs');

done_testing();