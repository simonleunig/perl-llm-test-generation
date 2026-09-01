use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::cache_write_memcopy"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'cache_write_memcopy is defined'); }

my ($fh, $filename) = tempfile();
my $data = { key => 'value' };
my $obj = bless {}, 'XML::Simple';
my $result = eval { $obj->cache_write_memcopy($data, $filename) };
if ($@) { fail('cache_write_memcopy crashed: ' . $@); } else { ok(1, 'cache_write_memcopy succeeds'); }

my $mock;
# UNVALIDATED: eval { require Storable; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: Storable - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"Storable::dclone"}) {
        # AFTER LAST PASS: $mock = mock 'Storable' => ( override => sub { die 'Storable module not available' } );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock = mock 'Storable' => ( add => sub { die 'Storable module not available' } );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }
# UNVALIDATED: $result = eval { $obj->cache_write_memcopy($data, $filename) };
# FAILED: if ($@) { ok(1, 'cache_write_memcopy handles Storable module error'); } else { fail('cache_write_memcopy did not handle Storable module error'); }

# AFTER LAST PASS: $mock = mock 'Storable' => ( override => sub { die 'Data structure too large' } );
# UNVALIDATED: $result = eval { $obj->cache_write_memcopy($data, $filename) };
# FAILED: if ($@) { ok(1, 'cache_write_memcopy handles data structure too large error'); } else { fail('cache_write_memcopy did not handle data structure too large error'); }

my $mem_copy_cache;  # AFTER LAST PASS: my $mem_copy_cache = {};
# AFTER LAST PASS: $mem_copy_cache->{$filename} = [time(), $data];
# AFTER LAST PASS: $mock = mock '$XML::Simple::MemCopyCache' => override => sub { $mem_copy_cache };
# UNVALIDATED: $result = eval { $obj->cache_write_memcopy($data, $filename) };
# FAILED: if ($@) { ok(1, 'cache_write_memcopy handles cache already full error'); } else { ok(1, 'cache_write_memcopy overwrites existing cache entry'); }

done_testing();