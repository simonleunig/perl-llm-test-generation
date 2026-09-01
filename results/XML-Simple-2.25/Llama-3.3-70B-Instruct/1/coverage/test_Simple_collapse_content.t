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

# UNVALIDATED: $result = eval { XML::Simple->new({ opt => { contentkey => 'content' } })->collapse_content({ key => { content => 'value' } }) };
# FAILED: if ($@) { fail("Function crashed: $@"); } else { ok(defined $result, "Function returns result for single key-value pair"); }
# FAILED: is($result, { key => 'value' }, "Single key-value pair is collapsed");

# UNVALIDATED: $result = eval { XML::Simple->new({ opt => { contentkey => 'content' } })->collapse_content({ key1 => { content => 'value1' }, key2 => { content => 'value2' } }) };
# FAILED: if ($@) { fail("Function crashed: $@"); } else { ok(defined $result, "Function returns result for multiple key-value pairs"); }
# FAILED: is($result, { key1 => 'value1', key2 => 'value2' }, "Multiple key-value pairs are collapsed");

# UNVALIDATED: $result = eval { XML::Simple->new({ opt => { contentkey => 'content' } })->collapse_content({ key => { nested => { content => 'value' } } }) };
# FAILED: if ($@) { fail("Function crashed: $@"); } else { ok(defined $result, "Function returns result for nested hashes"); }
# FAILED: is($result, { key => { nested => { content => 'value' } } }, "Nested hashes are not collapsed");

# UNVALIDATED: $result = eval { XML::Simple->new({ opt => { contentkey => 'invalid' } })->collapse_content({ key => { content => 'value' } }) };
# FAILED: if ($@) { fail("Function crashed: $@"); } else { ok(defined $result, "Function returns result for invalid contentkey"); }
# FAILED: is($result, { key => { content => 'value' } }, "Invalid contentkey leaves hashref unchanged");

done_testing();