use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::default_config_file"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'default_config_file is defined'); }

my $obj = bless {}, 'XML::Simple';
$obj->{opt} = { searchpath => [] };
my $result = eval { XML::Simple::default_config_file($obj) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }
like($result, qr/\.xml$/, 'Result is an XML file name');

$obj = bless {}, 'XML::Simple';
$obj->{opt} = { searchpath => [] };
my $script_dir = File::Spec->rel2abs('.');
my ($basename, $script_dir2, $ext) = File::Basename::fileparse($0, '\.[^\.]+');
my $expected_searchpath = [$script_dir2];
$result = eval { XML::Simple::default_config_file($obj) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }
is($obj->{opt}->{searchpath}[0], $expected_searchpath->[0], 'Script directory added to search path');

$obj = bless {}, 'XML::Simple';
$obj->{opt} = { searchpath => [] };
local $0 = '';
$result = eval { XML::Simple::default_config_file($obj) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }
is(scalar @{$obj->{opt}->{searchpath}}, 0, 'Script directory not added to search path');

done_testing();