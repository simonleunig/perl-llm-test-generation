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
my $cachefile = $object->storable_filename($filename);
open(my $cfh, '>', $cachefile) or die $!;
close($cfh);
utime(time() - 100, time() - 100, $cachefile); 
$result = eval { $object->cache_read_storable($filename) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result, 'Cache file is older than XML file'); }
# AFTER LAST PASS: close($fh);
# AFTER LAST PASS: unlink($filename);
# AFTER LAST PASS: unlink($cachefile);

my $mock;
# UNVALIDATED: eval { require Storable; };
# AFTER LAST PASS: if ($@) {
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"Storable::retrieve"}) {
        # AFTER LAST PASS: $mock = mock 'Storable' => ( override => [ retrieve => sub { return { foo => 'bar' } } ] );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock = mock 'Storable' => ( add => [ retrieve => sub { return { foo => 'bar' } } ] );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }
# AFTER LAST PASS: $object = bless {}, 'XML::Simple';
# AFTER LAST PASS: $object->storable_filename = sub { return $filename };
# AFTER LAST PASS: local $^O = 'VMS';
# UNVALIDATED: $result = eval { $object->cache_read_storable($filename) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Cache file exists and is up-to-date (VMS)'); }

# UNVALIDATED: eval { require Storable; };
# AFTER LAST PASS: if ($@) {
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"Storable::lock_retrieve"}) {
        # AFTER LAST PASS: $mock = mock 'Storable' => ( override => [ lock_retrieve => sub { return { foo => 'bar' } } ] );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock = mock 'Storable' => ( add => [ lock_retrieve => sub { return { foo => 'bar' } } ] );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }
# AFTER LAST PASS: $object = bless {}, 'XML::Simple';
# AFTER LAST PASS: $object->storable_filename = sub { return $filename };
# AFTER LAST PASS: local $^O = 'linux';
# UNVALIDATED: $result = eval { $object->cache_read_storable($filename) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Cache file exists and is up-to-date (non-VMS)'); }

done_testing();