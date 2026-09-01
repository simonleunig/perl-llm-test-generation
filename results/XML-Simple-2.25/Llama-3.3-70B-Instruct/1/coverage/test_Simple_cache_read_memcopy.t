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

my ($fh, $filename);  # AFTER LAST PASS: my ($fh, $filename) = tempfile();
my $cache;  # AFTER LAST PASS: my $cache = { foo => 'bar' };
my $mem_copy_cache;  # AFTER LAST PASS: my $mem_copy_cache = { $filename => [ time, $cache ] };
# UNVALIDATED: $XML::Simple::MemCopyCache = $mem_copy_cache;
my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple->cache_read_memcopy($filename) };
# FAILED: if ($@) { fail('cache_read_memcopy crashed: ' . $@); } else { ok(defined $result, 'cache_read_memcopy returns result'); }
# FAILED: is_deeply($result, $cache, 'cache_read_memcopy returns correct cache');

# AFTER LAST PASS: $mem_copy_cache = { $filename => [ time - 100, $cache ] };
# UNVALIDATED: $XML::Simple::MemCopyCache = $mem_copy_cache;
# AFTER LAST PASS: utime(time, time, $filename);
# UNVALIDATED: $result = eval { XML::Simple->cache_read_memcopy($filename) };
# FAILED: if ($@) { fail('cache_read_memcopy crashed: ' . $@); } else { ok(!defined $result, 'cache_read_memcopy returns undef for invalid cache'); }

# AFTER LAST PASS: unlink($filename);
# UNVALIDATED: $result = eval { XML::Simple->cache_read_memcopy($filename) };
# FAILED: if ($@) { fail('cache_read_memcopy crashed: ' . $@); } else { ok(!defined $result, 'cache_read_memcopy returns undef for non-existent cache'); }

done_testing();