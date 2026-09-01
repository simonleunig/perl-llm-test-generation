use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::cache_read_memshare"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'cache_read_memshare is defined'); }

my ($fh, $filename) = tempfile(UNLINK => 1);
my $cache_entry = [time, {key => 'value'}];
my $mock;
eval { require XML::Simple; };
if ($@) {
    # DEPENDENCY MISSING: XML::Simple - mock skipped
} else {
    no strict 'refs';
    if (defined &{"XML::Simple::MemShareCache"}) {
        $mock = mock 'XML::Simple' => (override => [
            MemShareCache => sub { return {$filename => $cache_entry} },
        ]);
    } else {
        $mock = mock 'XML::Simple' => (add => [
            MemShareCache => sub { return {$filename => $cache_entry} },
        ]);
    }
}
my $result = eval { XML::Simple->cache_read_memshare($filename) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result when cache entry exists and is up-to-date'); }
is_deeply($result, $cache_entry->[1], 'Correct result when cache entry exists and is up-to-date');

$cache_entry = [time - 100, {key => 'value'}];
$mock = mock 'XML::Simple' => (
    override => [
        MemShareCache => sub { return {$filename => $cache_entry} },
    ],
);
utime(time, time, $filename);
$result = eval { XML::Simple->cache_read_memshare($filename) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result, 'Function returns undef when cache entry exists but is outdated'); }

$mock = mock 'XML::Simple' => (
    override => [
        MemShareCache => sub { return {} },
    ],
);
$result = eval { XML::Simple->cache_read_memshare($filename) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result, 'Function returns undef when cache entry does not exist'); }

done_testing();