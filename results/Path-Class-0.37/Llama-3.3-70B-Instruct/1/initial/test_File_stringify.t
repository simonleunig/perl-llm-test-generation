use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::stringify"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'stringify is defined'); }

# Test case 1: File object with no directory
my $file_obj1 = bless { file => 'test_file.txt' }, 'Path::Class::File';
my $result1 = eval { Path::Class::File::stringify($file_obj1) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result1, 'test_file.txt', 'stringify returns file name without directory'); }

# Test case 2: File object with directory
my $dir_obj = bless { dir => 'test_dir' }, 'Path::Class::Dir';
my $file_obj2 = bless { file => 'test_file.txt', dir => $dir_obj }, 'Path::Class::File';
my $mock_spec = mock 'Path::Class::File' => ( _spec => bless {}, 'Path::Class::File' );
my $mock_catfile = mock $mock_spec->(_spec) => ( catfile => sub { join '/', @_ } );
my $result2 = eval { Path::Class::File::stringify($file_obj2) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result2, 'test_dir/test_file.txt', 'stringify returns file path with directory'); }

done_testing();
