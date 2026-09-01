use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::new_hashref"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'new_hashref is defined'); }

# Test case 1: Empty hash reference
my $result = eval { XML::Simple->new_hashref() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for empty hash'); }
is(ref $result, 'HASH', 'Result is a hash reference');

# Test case 2: Hash reference with key-value pairs
$result = eval { XML::Simple->new_hashref(key1 => 'value1', key2 => 'value2') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for hash with key-value pairs'); }
is(ref $result, 'HASH', 'Result is a hash reference');
is($result->{key1}, 'value1', 'Key1 has correct value');
is($result->{key2}, 'value2', 'Key2 has correct value');

# Test case 3: Hash reference with duplicate keys
$result = eval { XML::Simple->new_hashref(key1 => 'value1', key1 => 'value2') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for hash with duplicate keys'); }
is(ref $result, 'HASH', 'Result is a hash reference');
is($result->{key1}, 'value2', 'Key1 has correct value (last one wins)');

done_testing();
