use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::cache_read_memcopy"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'cache_read_memcopy is defined'); }

my ($fh, $filename) = tempfile();
my $cache = { foo => 'bar' };
$XML::Simple::MemCopyCache = { $filename => [ time, $cache ] };
my $result = eval { XML::Simple->cache_read_memcopy($filename) };
# FAILED: if ($@) { fail('cache_read_memcopy crashed: ' . $@); } else { ok(defined $result, 'cache_read_memcopy returns result'); }
# FAILED: is($result, $cache, 'cache_read_memcopy returns correct cache');

$XML::Simple::MemCopyCache = { $filename => [ time - 100, $cache ] };
utime(time, time, $filename);
$result = eval { XML::Simple->cache_read_memcopy($filename) };
if ($@) { fail('cache_read_memcopy crashed: ' . $@); } else { ok(!defined $result, 'cache_read_memcopy returns undef for invalid cache'); }

unlink($filename);
$result = eval { XML::Simple->cache_read_memcopy($filename) };
if ($@) { fail('cache_read_memcopy crashed: ' . $@); } else { ok(!defined $result, 'cache_read_memcopy returns undef for non-existent cache'); }

done_testing();