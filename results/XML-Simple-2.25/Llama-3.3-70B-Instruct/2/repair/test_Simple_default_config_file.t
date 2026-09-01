use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::default_config_file"} };
if ($@) { fail("Symbol check crashed: $@"); } else { ok($symbol_check, 'default_config_file is defined'); }

my $obj = bless {}, 'XML::Simple';
my $result = eval { XML::Simple::default_config_file($obj) };
if ($@) { fail("Function crashed: $@"); } else { ok(defined $result, 'default_config_file returns a result'); }

$result = eval { XML::Simple::default_config_file($obj) };
if ($@) { fail("Function crashed: $@"); } else { like($result, qr/\.xml$/, 'default_config_file returns a string with .xml extension'); }

my $temp_dir = tempdir();
my $script_name = 'test_script';
my $full_script_name = File::Spec->catfile($temp_dir, $script_name);
my $expected_searchpath = [$temp_dir];
$obj->{opt} = { searchpath => [] };
local $0 = $full_script_name;
$result = eval { XML::Simple::default_config_file($obj) };
if ($@) { fail("Function crashed: $@"); } else { is($obj->{opt}->{searchpath}, $expected_searchpath, 'default_config_file adds script directory to searchpath'); }

done_testing();