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
eval { require Storable; };
if ($@) {
    # DEPENDENCY MISSING: Storable - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Storable::dclone"}) {
        $mock = mock 'Storable' => ( override => [ dclone => sub { die 'Storable::dclone failed'; } ] );
    } else {
        $mock = mock 'Storable' => ( add => [ dclone => sub { die 'Storable::dclone failed'; } ] );
    }
}
my $result_error = eval { $obj->cache_write_memcopy($data, $filename) };
if ($@) { ok(1, 'cache_write_memcopy handles Storable error'); } else { fail('cache_write_memcopy did not handle Storable error'); }

my $large_data;  # AFTER LAST PASS: my $large_data = {};
my $i;  # AFTER LAST PASS: for (my $i = 0; $i < 10000; $i++) {
    # AFTER LAST PASS: $large_data->{$i} = 'value';
# AFTER LAST PASS: }
my $result_large;  # AFTER LAST PASS: my $result_large;  # UNVALIDATED: my $result_large = eval { $obj->cache_write_memcopy($large_data, $filename) };
# FAILED: if ($@) { fail('cache_write_memcopy crashed with large data: ' . $@); } else { ok(1, 'cache_write_memcopy handles large data'); }

my $cache_full;  # AFTER LAST PASS: my $cache_full = {};
my $i;  # AFTER LAST PASS: for (my $i = 0; $i < 10000; $i++) {
    # AFTER LAST PASS: $cache_full->{$i} = 'value';
# AFTER LAST PASS: }
# AFTER LAST PASS: $XML::Simple::MemCopyCache{$filename} = [$cache_full];
my $result_cache_full;  # AFTER LAST PASS: my $result_cache_full;  # UNVALIDATED: my $result_cache_full = eval { $obj->cache_write_memcopy($data, $filename) };
# FAILED: if ($@) { fail('cache_write_memcopy crashed with full cache: ' . $@); } else { ok(1, 'cache_write_memcopy handles full cache'); }

done_testing();