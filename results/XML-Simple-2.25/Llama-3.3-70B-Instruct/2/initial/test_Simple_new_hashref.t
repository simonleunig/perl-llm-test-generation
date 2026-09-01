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

# Test case: new_hashref returns a hash reference
my $result = eval { XML::Simple->new_hashref() };
if ($@) { fail('new_hashref crashed: ' . $@); } else { ok(ref($result) eq 'HASH', 'new_hashref returns a hash reference'); }

# Test case: new_hashref returns an empty hash reference
$result = eval { XML::Simple->new_hashref() };
if ($@) { fail('new_hashref crashed: ' . $@); } else { is(keys(%$result), 0, 'new_hashref returns an empty hash reference'); }

# Test case: new_hashref populates the hash reference with key-value pairs
$result = eval { XML::Simple->new_hashref(key1 => 'value1', key2 => 'value2') };
if ($@) { fail('new_hashref crashed: ' . $@); } else { is_deeply($result, {key1 => 'value1', key2 => 'value2'}, 'new_hashref populates the hash reference with key-value pairs'); }

done_testing();
