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
mock 'Storable' => (
    track => {
        dclone => sub { die 'Storable::dclone failed'; },
    },
);
my $result_error = eval { $obj->cache_write_memcopy($data, $filename) };
if ($@) { ok(1, 'cache_write_memcopy handles Storable error'); } else { fail('cache_write_memcopy did not handle Storable error'); }

# Test case 3: Edge case - Large data structure
my $large_data = {};
for (my $i = 0; $i < 10000; $i++) {
    $large_data->{$i} = 'value';
}
my $result_large = eval { $obj->cache_write_memcopy($large_data, $filename) };
if ($@) { fail('cache_write_memcopy crashed with large data: ' . $@); } else { ok(1, 'cache_write_memcopy handles large data'); }

# Test case 4: Edge case - Cache is already full
my $cache_full = {};
for (my $i = 0; $i < 10000; $i++) {
    $cache_full->{$i} = 'value';
}
$XML::Simple::MemCopyCache{$filename} = [$cache_full];
my $result_cache_full = eval { $obj->cache_write_memcopy($data, $filename) };
if ($@) { fail('cache_write_memcopy crashed with full cache: ' . $@); } else { ok(1, 'cache_write_memcopy handles full cache'); }

done_testing();
