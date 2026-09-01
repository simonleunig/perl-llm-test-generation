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

my ($fh, $filename) = tempfile();
my $data = { key => 'value' };
my $xml_simple = bless {}, 'XML::Simple';
my $result = eval { $xml_simple->cache_write_storable($data, $filename) };
if ($@) { fail('cache_write_storable crashed: ' . $@); } else { ok(-f $filename, 'Cache file written successfully'); }
unlink $filename;

my ($fh2, $filename2) = tempfile();
my $data2 = { key => 'value' };
my $xml_simple2 = bless {}, 'XML::Simple';
local $^O = 'VMS';
my $result2 = eval { $xml_simple2->cache_write_storable($data2, $filename2) };
if ($@) { fail('cache_write_storable crashed: ' . $@); } else { ok(-f $filename2, 'Cache file written successfully on VMS'); }
unlink $filename2;

my ($fh3, $filename3) = tempfile();
my $data3 = { key => 'value' };
my $xml_simple3 = bless {}, 'XML::Simple';
chmod 0444, $filename3; 
my $result3 = eval { $xml_simple3->cache_write_storable($data3, $filename3) };
if ($@) { ok($@, 'Cache write failed due to permissions issue'); } else { fail('Cache write succeeded unexpectedly'); }
chmod 0644, $filename3; 
unlink $filename3;

my ($fh4, $filename4) = tempfile();
my $data4 = { key => 'value' };
my $xml_simple4 = bless {}, 'XML::Simple';
my $mock;
eval { require Storable; };
if ($@) {
    # DEPENDENCY MISSING: Storable - mock skipped  
} else {
    no strict 'refs';
    if (defined &{"Storable::nstore"}) {
        $mock = mock 'Storable' => ( override => [ nstore => sub { die 'Mocked Storable::nstore' } ] );
    } else {
        $mock = mock 'Storable' => ( add => [ nstore => sub { die 'Mocked Storable::nstore' } ] );
    }
}
my $result4 = eval { $xml_simple4->cache_write_storable($data4, $filename4) };
if ($@) { ok($@, 'Cache write failed due to missing Storable module'); } else { fail('Cache write succeeded unexpectedly'); }
unlink $filename4;

done_testing();