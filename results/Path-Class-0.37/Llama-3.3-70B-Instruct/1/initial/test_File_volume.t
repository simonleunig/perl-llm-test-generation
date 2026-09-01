use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::volume"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'volume is defined'); }

# Test case: volume is defined
my $file = bless { dir => bless({}, 'Path::Class::Dir') }, 'Path::Class::File';
my $mock_volume = mock 'Path::Class::Dir' => ( volume => 'mock_volume' );
my $result = eval { $file->volume() };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'mock_volume', 'Volume is defined'); }

# Test case: volume is not defined
my $file_no_dir = bless {}, 'Path::Class::File';
$result = eval { $file_no_dir->volume() };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, '', 'Volume is not defined'); }

# Test case: volume method of dir object throws an error
my $file_dir_error = bless { dir => bless({}, 'Path::Class::Dir') }, 'Path::Class::File';
my $mock_error = mock 'Path::Class::Dir' => ( volume => sub { die 'Mock error' } );
$result = eval { $file_dir_error->volume() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Volume method error'); }

done_testing();
