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

my $temp_dir = tempdir(CLEANUP => 1);
my $filename = File::Spec->catfile($temp_dir, 'test.xml');
my $data = { key => 'value' };
my $xml_simple = bless {}, 'XML::Simple';

my $mock_storable;
eval { require Storable; };
if ($@) {
    # DEPENDENCY MISSING: Storable - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Storable::nstore"}) {
        $mock_storable = mock 'Storable' => (
            track => {
                nstore => sub { },
                lock_nstore => sub { },
            },
        );
    } else {
        $mock_storable = mock 'Storable' => (
            add => {
                nstore => sub { },
                lock_nstore => sub { },
            },
        );
    }
}

my $result = eval { $xml_simple->cache_write_storable($data, $filename) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }
is($mock_storable->call_count('lock_nstore'), 1, 'lock_nstore called once');

$mock_storable = mock 'Storable' => (
    track => {
        nstore => sub { },
        lock_nstore => sub { },
    },
);
my $mock_config = mock '$^O' => (
    override => sub { 'VMS' },
);
$result = eval { $xml_simple->cache_write_storable($data, $filename) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }
is($mock_storable->call_count('nstore'), 1, 'nstore called once');

$mock_storable = mock 'Storable' => (
    override => sub { die 'Storable module not installed' },
);
$result = eval { $xml_simple->cache_write_storable($data, $filename) };
if ($@) { ok($@ =~ /Storable module not installed/, 'Function crashes with Storable module not installed'); } else { fail('Function did not crash'); }

done_testing();