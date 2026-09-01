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
my $result = eval { $obj->default_config_file() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }
is(ref($result), '', 'Result is a string');

my $mock_fileparse;
eval { require File::Basename; };
if ($@) {
    # DEPENDENCY MISSING: File::Basename - mock skipped
} else {
    no strict 'refs';
    if (defined &{"File::Basename::fileparse"}) {
        $mock_fileparse = mock 'File::Basename' => (override => [fileparse => sub { return ('script_name', '/script/dir', '.pl') }]);
    } else {
        $mock_fileparse = mock 'File::Basename' => (add => [fileparse => sub { return ('script_name', '/script/dir', '.pl') }]);
    }
}
$obj->{opt} = { searchpath => [] };
$result = eval { $obj->default_config_file() };
if ($@) { fail('Function crashed: ' . $@); }
is(scalar(@{$obj->{opt}->{searchpath}}), 1, 'Script directory added to searchpath');
is($obj->{opt}->{searchpath}->[0], '/script/dir', 'Correct script directory added');

$mock_fileparse = mock 'File::Basename' => (override => [fileparse => sub { return ('script_name', '', '.pl') }]);
$obj->{opt} = { searchpath => [] };
$result = eval { $obj->default_config_file() };
if ($@) { fail('Function crashed: ' . $@); }
is(scalar(@{$obj->{opt}->{searchpath}}), 0, 'No script directory added when empty');

done_testing();