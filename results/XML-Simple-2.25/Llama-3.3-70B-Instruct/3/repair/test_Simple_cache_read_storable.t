use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::cache_read_storable"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'cache_read_storable is defined'); }

my ($fh, $filename) = tempfile();
my $object = bless {}, 'XML::Simple';
my $result = eval { $object->cache_read_storable($filename) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result, 'Cache file does not exist'); }
close($fh);
unlink($filename);

($fh, $filename) = tempfile();
chmod 0222, $filename;  
$object = bless {}, 'XML::Simple';
$result = eval { $object->cache_read_storable($filename) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result, 'Cache file is not readable'); }
chmod 0666, $filename;  
close($fh);
unlink($filename);

($fh, $filename) = tempfile();
$object = bless {}, 'XML::Simple';
utime(time() - 100, time() - 100, $filename);  
$result = eval { $object->cache_read_storable($filename) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result, 'Cache file is older than source file'); }
close($fh);
unlink($filename);

mock 'XML::Simple' => (
    override => [
        storable_filename => sub { return $filename; },
    ],
);
($fh, $filename) = tempfile();
$object = bless {}, 'XML::Simple';
utime(time() + 100, time() + 100, $filename);  
my $mock_storable = mock 'Storable' => (
    override => [
        retrieve => sub { return { key => 'value' }; },
        lock_retrieve => sub { return { key => 'value' }; },
    ],
);
local $^O = 'VMS';
$result = eval { $object->cache_read_storable($filename) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Cache file exists and is readable (VMS)'); }
close($fh);
unlink($filename);

mock 'XML::Simple' => (
    override => [
        storable_filename => sub { return $filename; },
    ],
);
($fh, $filename) = tempfile();
$object = bless {}, 'XML::Simple';
utime(time() + 100, time() + 100, $filename);  
$mock_storable = mock 'Storable' => (
    override => [
        retrieve => sub { return { key => 'value' }; },
        lock_retrieve => sub { return { key => 'value' }; },
    ],
);
local $^O = 'linux';
$result = eval { $object->cache_read_storable($filename) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Cache file exists and is readable (non-VMS)'); }
close($fh);
unlink($filename);

done_testing();