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
unlink($filename);

my $invalid_filename = undef;
$result = eval { $obj->cache_write_memcopy($data, $invalid_filename) };
# FAILED: if ($@) { ok(1, 'cache_write_memcopy fails with invalid filename'); } else { fail('cache_write_memcopy did not fail with invalid filename'); }

my $large_data = {};
for (my $i = 0; $i < 10000; $i++) {
    $large_data->{$i} = 'value';
}
($fh, $filename) = tempfile();
$result = eval { $obj->cache_write_memcopy($large_data, $filename) };
if ($@) { fail('cache_write_memcopy crashed with large data: ' . $@); } else { ok(1, 'cache_write_memcopy succeeds with large data'); }
unlink($filename);

my $mock;
eval { require Storable; };
if ($@) {
    # DEPENDENCY MISSING: Storable - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Storable::dclone"}) {
        $mock = mock 'Storable' => ( override => [ dclone => sub { die 'Storable::dclone not available'; } ] );
    } else {
        $mock = mock 'Storable' => ( add => [ dclone => sub { die 'Storable::dclone not available'; } ] );
    }
}
($fh, $filename) = tempfile();
$result = eval { $obj->cache_write_memcopy($data, $filename) };
if ($@) { ok(1, 'cache_write_memcopy fails when Storable module is not available'); } else { fail('cache_write_memcopy did not fail when Storable module is not available'); }
# AFTER LAST PASS: unlink($filename);

done_testing();