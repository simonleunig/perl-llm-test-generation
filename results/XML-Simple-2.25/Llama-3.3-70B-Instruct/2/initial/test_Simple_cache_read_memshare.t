use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::cache_read_memshare"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'cache_read_memshare is defined'); }

# Test case 1: Cache exists and is up-to-date
my ($fh, $filename) = tempfile();
my $cache_key = $filename;
my $cache_value = [time(), {'key' => 'value'}];
my %MemShareCache = ($cache_key => $cache_value);
my $result = eval { XML::Simple->cache_read_memshare($filename) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Cache exists and is up-to-date'); is_deeply($result, $cache_value->[1], 'Cache value matches'); }
unlink($filename);

# Test case 2: Cache exists but is outdated
($fh, $filename) = tempfile();
$cache_key = $filename;
$cache_value = [time() - 100, {'key' => 'value'}];
%MemShareCache = ($cache_key => $cache_value);
utime(time() + 100, $filename);
$result = eval { XML::Simple->cache_read_memshare($filename) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result, 'Cache exists but is outdated'); }
unlink($filename);

# Test case 3: Cache does not exist
($fh, $filename) = tempfile();
$result = eval { XML::Simple->cache_read_memshare($filename) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result, 'Cache does not exist'); }
unlink($filename);

done_testing();
