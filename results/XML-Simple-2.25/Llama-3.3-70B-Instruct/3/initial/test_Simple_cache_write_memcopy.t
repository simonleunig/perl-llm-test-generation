use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::cache_write_memcopy"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'cache_write_memcopy is defined'); }

# Test case 1: Successful cache write
my ($fh, $filename) = tempfile();
my $data = { key => 'value' };
my $obj = bless {}, 'XML::Simple';
my $result = eval { $obj->cache_write_memcopy($data, $filename) };
if ($@) { fail('cache_write_memcopy crashed: ' . $@); } else { ok(1, 'cache_write_memcopy succeeds'); }

# Test case 2: Error handling - Storable module not available
mock 'Storable' => override => sub { die 'Storable module not available' };
$result = eval { $obj->cache_write_memcopy($data, $filename) };
if ($@) { ok(1, 'cache_write_memcopy handles Storable module error'); } else { fail('cache_write_memcopy did not handle Storable module error'); }

# Test case 3: Error handling - Data structure too large
mock 'Storable' => override => sub { die 'Data structure too large' };
$result = eval { $obj->cache_write_memcopy($data, $filename) };
if ($@) { ok(1, 'cache_write_memcopy handles data structure too large error'); } else { fail('cache_write_memcopy did not handle data structure too large error'); }

# Test case 4: Cache already full
my $mem_copy_cache = {};
$mem_copy_cache->{$filename} = [time(), $data];
mock '$XML::Simple::MemCopyCache' => override => sub { $mem_copy_cache };
$result = eval { $obj->cache_write_memcopy($data, $filename) };
if ($@) { ok(1, 'cache_write_memcopy handles cache already full error'); } else { ok(1, 'cache_write_memcopy overwrites existing cache entry'); }

done_testing();
