use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::dir"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'dir is defined'); }

# Test case: dir method with existing directory
my $file_obj = bless({ dir => 'existing_dir' }, 'Path::Class::File');
my $result = eval { $file_obj->dir() };
if ($@) { fail('dir method crashed: ' . $@); } else { is($result, 'existing_dir', 'dir method returns existing directory'); }

# Test case: dir method without existing directory
my $mock_dir_class = mock 'Path::Class::Dir' => ( new => sub { return 'mock_dir' } );
my $mock_file_obj = bless({ dir_class => $mock_dir_class, _spec => bless({ curdir => 'mock_curdir' }, 'Path::Class::Spec') }, 'Path::Class::File');
$result = eval { $mock_file_obj->dir() };
if ($@) { fail('dir method crashed: ' . $@); } else { is($result, 'mock_dir', 'dir method returns new directory'); }

# Test case: dir method with invalid input
my $invalid_file_obj = bless({}, 'Invalid::File');
$result = eval { $invalid_file_obj->dir() };
if ($@) { fail('dir method crashed: ' . $@); } else { ok(!defined $result, 'dir method returns undef for invalid input'); }

done_testing();
