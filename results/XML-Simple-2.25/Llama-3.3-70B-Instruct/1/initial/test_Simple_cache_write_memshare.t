use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::cache_write_memshare"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'cache_write_memshare is defined'); }

# Test case 1: Valid input
my $data = { key => 'value' };
my $filename = 'test.xml';
my $result = eval { XML::Simple->cache_write_memshare($data, $filename) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result with valid input'); }

# Test case 2: Invalid input - no filename
$data = { key => 'value' };
$result = eval { XML::Simple->cache_write_memshare($data) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result, 'Function returns no result with no filename'); }

# Test case 3: Invalid input - no data
$filename = 'test.xml';
$result = eval { XML::Simple->cache_write_memshare(undef, $filename) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result, 'Function returns no result with no data'); }

# Test case 4: Cache hit
$data = { key => 'value' };
$filename = 'test.xml';
eval { XML::Simple->cache_write_memshare($data, $filename) };
$result = eval { XML::Simple->cache_write_memshare($data, $filename) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result on cache hit'); }

done_testing();
