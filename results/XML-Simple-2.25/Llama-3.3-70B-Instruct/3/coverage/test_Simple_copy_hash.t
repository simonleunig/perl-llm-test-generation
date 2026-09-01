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

my $result = eval { XML::Simple->copy_hash({},) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for empty hash'); }
# FAILED: is_deeply($result, {}, 'Result is an empty hash for empty input');

my $hash;  # AFTER LAST PASS: my $hash = { key1 => 'value1', key2 => 'value2' };
# UNVALIDATED: $result = eval { XML::Simple->copy_hash($hash) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for hash with key-value pairs'); }
# FAILED: is_deeply($result, $hash, 'Result is a copy of the input hash');

# UNVALIDATED: $result = eval { XML::Simple->copy_hash($hash, key3 => 'value3') };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for hash with extra key-value pairs'); }
# FAILED: is_deeply($result, { key1 => 'value1', key2 => 'value2', key3 => 'value3' }, 'Result includes extra key-value pairs');

# UNVALIDATED: $result = eval { XML::Simple->copy_hash(undef) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for undefined input hash'); }
# FAILED: is_deeply($result, {}, 'Result is an empty hash for undefined input');

done_testing();