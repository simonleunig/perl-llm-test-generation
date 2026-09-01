use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw(tempfile tempdir);
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::cache_read_storable"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'cache_read_storable is defined'); }

my ($fh, $filename) = tempfile();
my $object = bless {}, 'XML::Simple';
my $result = eval { $object->cache_read_storable($filename) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result, 'Cache file does not exist'); }
close $fh;
unlink $filename;

($fh, $filename) = tempfile();
chmod 0222, $filename;
$object = bless {}, 'XML::Simple';
$result = eval { $object->cache_read_storable($filename) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result, 'Cache file is not readable'); }
chmod 0666, $filename;
close $fh;
unlink $filename;

($fh, $filename) = tempfile();
my $xml_filename = $filename . '.xml';
open my $xml_fh, '>', $xml_filename;
close $xml_fh;
utime time, time + 1, $xml_filename;
$object = bless {}, 'XML::Simple';
my $mock;
eval { require XML::Simple; };
if ($@) {
    # DEPENDENCY MISSING: XML::Simple - mock skipped  
} else {
    no strict 'refs';
    if (defined &{"XML::Simple::storable_filename"}) {
        $mock = mock 'XML::Simple' => ( override => [ 'storable_filename' => sub { return $filename; } ] );
    } else {
        $mock = mock 'XML::Simple' => ( add => [ 'storable_filename' => sub { return $filename; } ] );
    }
}
$result = eval { $object->cache_read_storable($xml_filename) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result, 'Cache file is older than the corresponding XML file'); }
# AFTER LAST PASS: close $fh;
# AFTER LAST PASS: unlink $filename;
# AFTER LAST PASS: unlink $xml_filename;

# AFTER LAST PASS: ($fh, $filename) = tempfile();
# AFTER LAST PASS: $object = bless {}, 'XML::Simple';
# UNVALIDATED: eval { require Storable; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: Storable - mock skipped  
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"Storable::retrieve"}) {
        # AFTER LAST PASS: $mock = mock 'Storable' => ( override => [ 'retrieve' => sub { return 'cached_data'; } ] );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock = mock 'Storable' => ( add => [ 'retrieve' => sub { return 'cached_data'; } ] );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }
# UNVALIDATED: eval { require XML::Simple; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: XML::Simple - mock skipped  
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"XML::Simple::storable_filename"}) {
        # AFTER LAST PASS: $mock = mock 'XML::Simple' => ( override => [ 'storable_filename' => sub { return $filename; } ] );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock = mock 'XML::Simple' => ( add => [ 'storable_filename' => sub { return $filename; } ] );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }
# UNVALIDATED: $result = eval { local $^O = 'VMS'; $object->cache_read_storable($filename) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'cached_data', 'Cache file exists and is up-to-date (VMS)'); }
# AFTER LAST PASS: close $fh;
# AFTER LAST PASS: unlink $filename;

# AFTER LAST PASS: ($fh, $filename) = tempfile();
# AFTER LAST PASS: $object = bless {}, 'XML::Simple';
# UNVALIDATED: eval { require Storable; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: Storable - mock skipped  
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"Storable::lock_retrieve"}) {
        # AFTER LAST PASS: $mock = mock 'Storable' => ( override => [ 'lock_retrieve' => sub { return 'cached_data'; } ] );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock = mock 'Storable' => ( add => [ 'lock_retrieve' => sub { return 'cached_data'; } ] );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }
# UNVALIDATED: eval { require XML::Simple; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: XML::Simple - mock skipped  
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"XML::Simple::storable_filename"}) {
        # AFTER LAST PASS: $mock = mock 'XML::Simple' => ( override => [ 'storable_filename' => sub { return $filename; } ] );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock = mock 'XML::Simple' => ( add => [ 'storable_filename' => sub { return $filename; } ] );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }
# UNVALIDATED: $result = eval { $object->cache_read_storable($filename) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'cached_data', 'Cache file exists and is up-to-date (non-VMS)'); }
# AFTER LAST PASS: close $fh;
# AFTER LAST PASS: unlink $filename;

done_testing();