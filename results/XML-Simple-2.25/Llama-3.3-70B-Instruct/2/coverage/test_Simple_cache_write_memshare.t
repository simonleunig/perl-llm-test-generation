use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::cache_write_memshare"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'cache_write_memshare is defined'); }

my $data = { key => 'value' };
my $filename = 'test.xml';
my $result = eval { XML::Simple->cache_write_memshare($data, $filename) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result with valid input'); }

# AFTER LAST PASS: $data = { key => 'value' };
# UNVALIDATED: $result = eval { XML::Simple->cache_write_memshare($data) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result, 'Function returns no result with no filename'); }

# AFTER LAST PASS: $filename = 'test.xml';
# UNVALIDATED: $result = eval { XML::Simple->cache_write_memshare(undef, $filename) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result, 'Function returns no result with no data'); }

# AFTER LAST PASS: $data = { key => 'value' };
# AFTER LAST PASS: $filename = 'test.xml';
# UNVALIDATED: eval { XML::Simple->cache_write_memshare($data, $filename) };
my $cached_data;  # AFTER LAST PASS: my $cached_data;  # UNVALIDATED: my $cached_data = eval { $XML::Simple::MemShareCache{$filename} };
# FAILED: if ($@) { fail('Cache check crashed: ' . $@); } else { is($cached_data->[1], $data, 'Cache stores data correctly'); }

done_testing();