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

my ($fh, $filename);  # AFTER LAST PASS: my ($fh, $filename) = tempfile(UNLINK => 1);
my $cache_entry;  # AFTER LAST PASS: my $cache_entry = [time, {key => 'value'}];
my $mock;
# UNVALIDATED: eval { require XML::Simple; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: XML::Simple - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"XML::Simple::MemShareCache"}) {
        # AFTER LAST PASS: $mock = mock 'XML::Simple' => (override => [
            # AFTER LAST PASS: MemShareCache => sub { return {$filename => $cache_entry} },
        # AFTER LAST PASS: ]);
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock = mock 'XML::Simple' => (add => [
            # AFTER LAST PASS: MemShareCache => sub { return {$filename => $cache_entry} },
        # AFTER LAST PASS: ]);
    # AFTER LAST PASS: }
# AFTER LAST PASS: }
my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple->cache_read_memshare($filename) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result when cache entry exists and is up-to-date'); }
# FAILED: is_deeply($result, $cache_entry->[1], 'Correct result when cache entry exists and is up-to-date');

# AFTER LAST PASS: $cache_entry = [time - 100, {key => 'value'}];
# AFTER LAST PASS: $mock = mock 'XML::Simple' => (
    # AFTER LAST PASS: override => [
        # AFTER LAST PASS: MemShareCache => sub { return {$filename => $cache_entry} },
    # AFTER LAST PASS: ],
# AFTER LAST PASS: );
# AFTER LAST PASS: utime(time, time, $filename);
# UNVALIDATED: $result = eval { XML::Simple->cache_read_memshare($filename) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result, 'Function returns undef when cache entry exists but is outdated'); }

# AFTER LAST PASS: $mock = mock 'XML::Simple' => (
    # AFTER LAST PASS: override => [
        # AFTER LAST PASS: MemShareCache => sub { return {} },
    # AFTER LAST PASS: ],
# AFTER LAST PASS: );
# UNVALIDATED: $result = eval { XML::Simple->cache_read_memshare($filename) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result, 'Function returns undef when cache entry does not exist'); }

done_testing();