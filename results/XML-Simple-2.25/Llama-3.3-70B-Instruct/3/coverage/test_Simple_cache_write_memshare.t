use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::cache_write_memshare"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'cache_write_memshare is defined'); }

# Test case 1: Normal operation
my ($fh, $filename) = tempfile();
my $data = { key => 'value' };
my $result = eval { XML::Simple->cache_write_memshare($data, $filename) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }

# Test case 2: Edge case - empty data
$result = eval { XML::Simple->cache_write_memshare({}, $filename) };
if ($@) { fail('Function crashed with empty data: ' . $@); } else { ok(defined $result, 'Function returns result with empty data'); }

# Test case 3: Edge case - invalid data
$result = eval { XML::Simple->cache_write_memshare('invalid', $filename) };
if ($@) { fail('Function crashed with invalid data: ' . $@); } else { ok(defined $result, 'Function returns result with invalid data'); }

# Test case 4: Edge case - empty filename
$result = eval { XML::Simple->cache_write_memshare($data, '') };
if ($@) { fail('Function crashed with empty filename: ' . $@); } else { ok(defined $result, 'Function returns result with empty filename'); }

# Test case 5: Cache overwrite
my $new_data = { key => 'new_value' };
$result = eval { XML::Simple->cache_write_memshare($new_data, $filename) };
if ($@) { fail('Function crashed on cache overwrite: ' . $@); } else { ok(defined $result, 'Function returns result on cache overwrite'); }

done_testing();
