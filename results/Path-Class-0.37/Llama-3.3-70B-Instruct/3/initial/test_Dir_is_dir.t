use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::is_dir"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'is_dir is defined'); }

# Test cases with eval protection
my $dir = Path::Class::Dir->new('test_dir');
my $result = eval { $dir->is_dir() };
if ($@) { fail('is_dir crashed: ' . $@); } else { is($result, 1, 'is_dir returns 1'); }

# Test with a mock object
my $mock_dir = mock 'Path::Class::Dir' => ( override => [ 'is_dir' => sub { 0 } ] );
$result = eval { $mock_dir->is_dir() };
if ($@) { fail('Mock is_dir crashed: ' . $@); } else { is($result, 0, 'Mock is_dir returns 0'); }

done_testing();
