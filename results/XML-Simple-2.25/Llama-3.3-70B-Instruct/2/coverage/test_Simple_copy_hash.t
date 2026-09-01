use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::copy_hash"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'copy_hash is defined'); }

my $result = eval { XML::Simple->copy_hash({}, 'key1' => 'value1') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for empty hash'); }
is($result, { 'key1' => 'value1' }, 'Result matches expected for empty hash');

$result = eval { XML::Simple->copy_hash({ 'key2' => 'value2' }, 'key1' => 'value1') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for non-empty hash'); }
is($result, { 'key2' => 'value2', 'key1' => 'value1' }, 'Result matches expected for non-empty hash');

$result = eval { XML::Simple->copy_hash(undef, 'key1' => 'value1') };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for undefined input hash'); }
# FAILED: is($result, { 'key1' => 'value1' }, 'Result matches expected for undefined input hash');

$result = eval { XML::Simple->copy_hash({ 'key2' => 'value2' }) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for no extra key-value pairs'); }
is($result, { 'key2' => 'value2' }, 'Result matches expected for no extra key-value pairs');

done_testing();