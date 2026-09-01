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
close $fh;
unlink $filename;

# Test case 2: Cache file is not readable
($fh, $filename) = tempfile();
chmod 0222, $filename;
$object = bless {}, 'XML::Simple';
$result = eval { $object->cache_read_storable($filename) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result, 'Cache file is not readable'); }
chmod 0666, $filename;
close $fh;
unlink $filename;

# Test case 3: Cache file is older than the corresponding XML file
($fh, $filename) = tempfile();
my $xml_filename = $filename . '.xml';
open my $xml_fh, '>', $xml_filename;
close $xml_fh;
utime time, time + 1, $xml_filename;
$object = bless {}, 'XML::Simple';
mock $object => (
    add_callback => sub { 'storable_filename' => sub { return $filename; } },
);
$result = eval { $object->cache_read_storable($xml_filename) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result, 'Cache file is older than the corresponding XML file'); }
close $fh;
unlink $filename;
unlink $xml_filename;

# Test case 4: Cache file exists and is up-to-date (VMS)
($fh, $filename) = tempfile();
$object = bless {}, 'XML::Simple';
mock $object => (
    add_callback => sub { 'storable_filename' => sub { return $filename; } },
);
my $storable_mock = mock 'Storable' => (
    add_callback => sub { 'retrieve' => sub { return 'cached_data'; } },
);
$result = eval { local $^O = 'VMS'; $object->cache_read_storable($filename) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'cached_data', 'Cache file exists and is up-to-date (VMS)'); }
close $fh;
unlink $filename;

# Test case 5: Cache file exists and is up-to-date (non-VMS)
($fh, $filename) = tempfile();
$object = bless {}, 'XML::Simple';
mock $object => (
    add_callback => sub { 'storable_filename' => sub { return $filename; } },
);
$storable_mock = mock 'Storable' => (
    add_callback => sub { 'lock_retrieve' => sub { return 'cached_data'; } },
);
$result = eval { $object->cache_read_storable($filename) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'cached_data', 'Cache file exists and is up-to-date (non-VMS)'); }
close $fh;
unlink $filename;

done_testing();
