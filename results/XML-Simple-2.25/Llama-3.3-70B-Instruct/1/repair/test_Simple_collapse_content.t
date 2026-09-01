use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::collapse_content"} };
if ($@) { fail("Symbol check crashed: $@"); } else { ok($symbol_check, "collapse_content is defined"); }

my $result = eval { XML::Simple->new()->collapse_content({}) };
if ($@) { fail("Function crashed: $@"); } else { ok(defined $result, "Function returns result for empty hashref"); }
is($result, {}, "Empty hashref remains unchanged");

$result = eval { XML::Simple->new({ opt => { contentkey => 'content' } })->collapse_content({ key => { content => 'value' } }) };
if ($@) { fail("Function crashed: $@"); } else { ok(defined $result, "Function returns result for single key-value pair"); }
is($result, { key => 'value' }, "Single key-value pair is collapsed");

$result = eval { XML::Simple->new({ opt => { contentkey => 'content' } })->collapse_content({ key1 => { content => 'value1' }, key2 => { content => 'value2' } }) };
if ($@) { fail("Function crashed: $@"); } else { ok(defined $result, "Function returns result for multiple key-value pairs"); }
is($result, { key1 => 'value1', key2 => 'value2' }, "Multiple key-value pairs are collapsed");

$result = eval { XML::Simple->new({ opt => { contentkey => 'content' } })->collapse_content({ key => { nested => { content => 'value' } } }) };
if ($@) { fail("Function crashed: $@"); } else { ok(defined $result, "Function returns result for nested hashes"); }
is($result, { key => { nested => { content => 'value' } } }, "Nested hashes are not collapsed");

$result = eval { XML::Simple->new({ opt => { contentkey => 'invalid' } })->collapse_content({ key => { content => 'value' } }) };
if ($@) { fail("Function crashed: $@"); } else { ok(defined $result, "Function returns result for invalid contentkey"); }
is($result, { key => { content => 'value' } }, "Invalid contentkey leaves hashref unchanged");

done_testing();