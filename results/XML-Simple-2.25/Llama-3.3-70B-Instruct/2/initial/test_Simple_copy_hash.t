use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::copy_hash"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'copy_hash is defined'); }

# Test case 1: Empty hash reference
my $result = eval { XML::Simple->copy_hash({}, 'key1' => 'value1') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for empty hash'); }
is_deeply($result, { 'key1' => 'value1' }, 'Result matches expected for empty hash');

# Test case 2: Non-empty hash reference
$result = eval { XML::Simple->copy_hash({ 'key2' => 'value2' }, 'key1' => 'value1') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for non-empty hash'); }
is_deeply($result, { 'key2' => 'value2', 'key1' => 'value1' }, 'Result matches expected for non-empty hash');

# Test case 3: Undefined input hash reference
$result = eval { XML::Simple->copy_hash(undef, 'key1' => 'value1') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for undefined input hash'); }
is_deeply($result, { 'key1' => 'value1' }, 'Result matches expected for undefined input hash');

# Test case 4: No extra key-value pairs
$result = eval { XML::Simple->copy_hash({ 'key2' => 'value2' }) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for no extra key-value pairs'); }
is_deeply($result, { 'key2' => 'value2' }, 'Result matches expected for no extra key-value pairs');

done_testing();
