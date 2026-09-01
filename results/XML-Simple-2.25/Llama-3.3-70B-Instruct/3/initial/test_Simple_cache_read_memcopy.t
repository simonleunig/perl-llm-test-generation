use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::cache_read_memcopy"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'cache_read_memcopy is defined'); }

# Test case: cache_read_memcopy with valid cache
my ($fh, $filename) = tempfile();
my $cache = { foo => 'bar' };
my $mem_copy_cache = { $filename => [ time, $cache ] };
my $result = eval { XML::Simple->cache_read_memcopy($filename) };
if ($@) { fail('cache_read_memcopy crashed: ' . $@); } else { ok(defined $result, 'cache_read_memcopy returns result'); }
is($result, $cache, 'cache_read_memcopy returns correct cache');

# Test case: cache_read_memcopy with invalid cache
$mem_copy_cache = { $filename => [ time - 100, $cache ] };
utime(time, time, $filename);
$result = eval { XML::Simple->cache_read_memcopy($filename) };
if ($@) { fail('cache_read_memcopy crashed: ' . $@); } else { ok(!defined $result, 'cache_read_memcopy returns undef for invalid cache'); }

# Test case: cache_read_memcopy with non-existent cache
unlink($filename);
$result = eval { XML::Simple->cache_read_memcopy($filename) };
if ($@) { fail('cache_read_memcopy crashed: ' . $@); } else { ok(!defined $result, 'cache_read_memcopy returns undef for non-existent cache'); }

done_testing();
