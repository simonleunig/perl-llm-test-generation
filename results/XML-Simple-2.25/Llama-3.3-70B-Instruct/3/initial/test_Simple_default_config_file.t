use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::default_config_file"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'default_config_file is defined'); }

# Test case: default_config_file returns a string
my $obj = bless {}, 'XML::Simple';
$obj->{opt} = { searchpath => [] };
my $result = eval { XML::Simple::default_config_file($obj) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }
like($result, qr/\.xml$/, 'Result is an XML file name');

# Test case: default_config_file adds script directory to search path
$obj = bless {}, 'XML::Simple';
$obj->{opt} = { searchpath => [] };
my $script_dir = File::Spec->rel2abs('.');
my ($basename, $script_dir2, $ext) = File::Basename::fileparse($0, '\.[^\.]+');
my $expected_searchpath = [$script_dir2];
$result = eval { XML::Simple::default_config_file($obj) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }
is_deeply($obj->{opt}->{searchpath}, $expected_searchpath, 'Script directory added to search path');

# Test case: default_config_file does not add script directory to search path if it is not available
$obj = bless {}, 'XML::Simple';
$obj->{opt} = { searchpath => [] };
local $0 = '';
$result = eval { XML::Simple::default_config_file($obj) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }
is_deeply($obj->{opt}->{searchpath}, [], 'Script directory not added to search path');

done_testing();
