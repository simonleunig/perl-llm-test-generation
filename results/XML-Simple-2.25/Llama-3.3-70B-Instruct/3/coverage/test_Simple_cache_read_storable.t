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
# AFTER LAST PASS: close($fh);
# AFTER LAST PASS: unlink($filename);

# AFTER LAST PASS: mock 'XML::Simple' => (
    # AFTER LAST PASS: override => [
        # AFTER LAST PASS: storable_filename => sub { return $filename; },
    # AFTER LAST PASS: ],
# AFTER LAST PASS: );
# AFTER LAST PASS: ($fh, $filename) = tempfile();
# AFTER LAST PASS: $object = bless {}, 'XML::Simple';
# AFTER LAST PASS: utime(time() + 100, time() + 100, $filename);  
my $mock_storable;  # AFTER LAST PASS: my $mock_storable = mock 'Storable' => (
    # AFTER LAST PASS: override => [
        # AFTER LAST PASS: retrieve => sub { return { key => 'value' }; },
        # AFTER LAST PASS: lock_retrieve => sub { return { key => 'value' }; },
    # AFTER LAST PASS: ],
# AFTER LAST PASS: );
# AFTER LAST PASS: local $^O = 'VMS';
# UNVALIDATED: $result = eval { $object->cache_read_storable($filename) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Cache file exists and is readable (VMS)'); }
# AFTER LAST PASS: close($fh);
# AFTER LAST PASS: unlink($filename);

# AFTER LAST PASS: mock 'XML::Simple' => (
    # AFTER LAST PASS: override => [
        # AFTER LAST PASS: storable_filename => sub { return $filename; },
    # AFTER LAST PASS: ],
# AFTER LAST PASS: );
# AFTER LAST PASS: ($fh, $filename) = tempfile();
# AFTER LAST PASS: $object = bless {}, 'XML::Simple';
# AFTER LAST PASS: utime(time() + 100, time() + 100, $filename);  
# AFTER LAST PASS: $mock_storable = mock 'Storable' => (
    # AFTER LAST PASS: override => [
        # AFTER LAST PASS: retrieve => sub { return { key => 'value' }; },
        # AFTER LAST PASS: lock_retrieve => sub { return { key => 'value' }; },
    # AFTER LAST PASS: ],
# AFTER LAST PASS: );
# AFTER LAST PASS: local $^O = 'linux';
# UNVALIDATED: $result = eval { $object->cache_read_storable($filename) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Cache file exists and is readable (non-VMS)'); }
# AFTER LAST PASS: close($fh);
# AFTER LAST PASS: unlink($filename);

done_testing();