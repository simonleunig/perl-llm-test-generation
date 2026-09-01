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
my $result = eval { XML::Simple->copy_hash({},) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for empty hash'); }
is_deeply($result, {}, 'Result is an empty hash for empty input');

# Test case 2: Hash reference with key-value pairs
my $hash = { key1 => 'value1', key2 => 'value2' };
$result = eval { XML::Simple->copy_hash($hash) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for hash with key-value pairs'); }
is_deeply($result, $hash, 'Result is a copy of the input hash');

# Test case 3: Hash reference with extra key-value pairs
$result = eval { XML::Simple->copy_hash($hash, key3 => 'value3') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for hash with extra key-value pairs'); }
is_deeply($result, { key1 => 'value1', key2 => 'value2', key3 => 'value3' }, 'Result includes extra key-value pairs');

# Test case 4: Undefined input hash reference
$result = eval { XML::Simple->copy_hash(undef) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for undefined input hash'); }
is_deeply($result, {}, 'Result is an empty hash for undefined input');

done_testing();
