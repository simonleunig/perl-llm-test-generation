use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::cache_read_memshare"} };
if ($@) { fail("Symbol check crashed: $@"); } else { ok($symbol_check, "cache_read_memshare is defined"); }

my ($fh, $filename);  # AFTER LAST PASS: my ($fh, $filename) = tempfile();
my $cache_key;  # AFTER LAST PASS: my $cache_key = $filename;
my $cache_value;  # AFTER LAST PASS: my $cache_value = [time(), {'key' => 'value'}];
my %MemShareCache;  # AFTER LAST PASS: my %MemShareCache = ($cache_key => $cache_value);
my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple->cache_read_memshare($filename) };
# FAILED: if ($@) { fail("Function crashed: $@"); } else { ok(defined $result, "Cache exists and is up-to-date"); is_deeply($result, $cache_value->[1], "Cache value matches"); }
# AFTER LAST PASS: unlink($filename);

# AFTER LAST PASS: ($fh, $filename) = tempfile();
# AFTER LAST PASS: $cache_key = $filename;
# AFTER LAST PASS: $cache_value = [time() - 100, {'key' => 'value'}];
# AFTER LAST PASS: %MemShareCache = ($cache_key => $cache_value);
# AFTER LAST PASS: utime(time() + 100, $filename);
# UNVALIDATED: $result = eval { XML::Simple->cache_read_memshare($filename) };
# FAILED: if ($@) { fail("Function crashed: $@"); } else { ok(!defined $result, "Cache exists but is outdated"); }
# AFTER LAST PASS: unlink($filename);

# AFTER LAST PASS: ($fh, $filename) = tempfile();
# UNVALIDATED: $result = eval { XML::Simple->cache_read_memshare($filename) };
# FAILED: if ($@) { fail("Function crashed: $@"); } else { ok(!defined $result, "Cache does not exist"); }
# AFTER LAST PASS: unlink($filename);

done_testing();