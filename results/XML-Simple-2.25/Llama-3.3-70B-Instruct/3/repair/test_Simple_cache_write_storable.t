use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::cache_write_storable"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'cache_write_storable is defined'); }

my $tempdir = tempdir(CLEANUP => 1);
my $filename = File::Spec->catfile($tempdir, 'test.xml');
my $data = { key => 'value' };
my $simple = bless {}, 'XML::Simple';

my $result = eval { $simple->cache_write_storable($data, $filename) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(1, 'Normal operation on non-VMS system'); }

my $mock;
eval { require XML::Simple; };
if ($@) {
    fail('Module loading failed');
} else {
    no strict 'refs';
    if (defined &{"XML::Simple::storable_filename"}) {
        $mock = mock 'XML::Simple' => ( override => [ storable_filename => sub { return 'vms_test.xml' } ] );
    } else {
        $mock = mock 'XML::Simple' => ( add => [ storable_filename => sub { return 'vms_test.xml' } ] );
    }
}

my $vms_simple = bless {}, 'XML::Simple';
local $^O = 'VMS';
my $vms_result = eval { $vms_simple->cache_write_storable($data, $filename) };
if ($@) { fail('Function crashed on VMS: ' . $@); } else { ok(1, 'Normal operation on VMS system'); }

my $invalid_data = 'invalid';
my $invalid_result = eval { $simple->cache_write_storable($invalid_data, $filename) };
if ($@) { ok(1, 'Error handling - invalid data'); } else { fail('Expected function to crash with invalid data'); }

my $readonly_file = tempfile(UNLINK => 1);
my $readonly_filename = $readonly_file->filename;
close $readonly_file;
chmod 0444, $readonly_filename;
my $readonly_result = eval { $simple->cache_write_storable($data, $readonly_filename) };
if ($@) { ok(1, 'Error handling - file cannot be written'); } else { fail('Expected function to crash when file cannot be written'); }

done_testing();