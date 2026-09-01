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
my $result = eval { $obj->default_config_file() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }
is(ref($result), '', 'Result is a string');

# Test case: default_config_file adds script directory to searchpath
my $mock_fileparse = mock 'File::Basename' => (fileparse => sub { return ('script_name', '/script/dir', '.pl') });
$obj->{opt} = { searchpath => [] };
$result = eval { $obj->default_config_file() };
if ($@) { fail('Function crashed: ' . $@); }
is(scalar(@{$obj->{opt}->{searchpath}}), 1, 'Script directory added to searchpath');
is($obj->{opt}->{searchpath}->[0], '/script/dir', 'Correct script directory added');

# Test case: default_config_file does not add script directory to searchpath if it's empty
$mock_fileparse = mock 'File::Basename' => (fileparse => sub { return ('script_name', '', '.pl') });
$obj->{opt} = { searchpath => [] };
$result = eval { $obj->default_config_file() };
if ($@) { fail('Function crashed: ' . $@); }
is(scalar(@{$obj->{opt}->{searchpath}}), 0, 'No script directory added when empty');

done_testing();
