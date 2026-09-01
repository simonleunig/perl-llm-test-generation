use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::cache_read_storable"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'cache_read_storable is defined'); }

# Test case 1: Cache file does not exist
my ($fh, $filename) = tempfile();
my $object = bless {}, 'XML::Simple';
my $result = eval { $object->cache_read_storable($filename) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result, 'Cache file does not exist'); }
close($fh);
unlink($filename);

# Test case 2: Cache file exists but is not readable
($fh, $filename) = tempfile();
chmod 0222, $filename;  # Make file not readable
$object = bless {}, 'XML::Simple';
$result = eval { $object->cache_read_storable($filename) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result, 'Cache file is not readable'); }
chmod 0666, $filename;  # Restore file permissions
close($fh);
unlink($filename);

# Test case 3: Cache file exists and is readable, but is older than source file
($fh, $filename) = tempfile();
$object = bless {}, 'XML::Simple';
utime(time() - 100, time() - 100, $filename);  # Make cache file older
$result = eval { $object->cache_read_storable($filename) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result, 'Cache file is older than source file'); }
close($fh);
unlink($filename);

# Test case 4: Cache file exists, is readable, and is newer than source file (VMS)
mock 'XML::Simple' => (
    override => [
        storable_filename => sub { return $filename; },
    ],
);
($fh, $filename) = tempfile();
$object = bless {}, 'XML::Simple';
utime(time() + 100, time() + 100, $filename);  # Make cache file newer
my $mock_storable = mock 'Storable' => (
    override => [
        retrieve => sub { return { key => 'value' }; },
    ],
);
local $^O = 'VMS';
$result = eval { $object->cache_read_storable($filename) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Cache file exists and is readable (VMS)'); }
close($fh);
unlink($filename);

# Test case 5: Cache file exists, is readable, and is newer than source file (non-VMS)
mock 'XML::Simple' => (
    override => [
        storable_filename => sub { return $filename; },
    ],
);
($fh, $filename) = tempfile();
$object = bless {}, 'XML::Simple';
utime(time() + 100, time() + 100, $filename);  # Make cache file newer
$mock_storable = mock 'Storable' => (
    override => [
        lock_retrieve => sub { return { key => 'value' }; },
    ],
);
local $^O = 'linux';
$result = eval { $object->cache_read_storable($filename) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Cache file exists and is readable (non-VMS)'); }
close($fh);
unlink($filename);

done_testing();
