use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::rmtree"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'rmtree is defined'); }

# Create a temporary directory
my $temp_dir = tempdir(CLEANUP => 1);
my $dir = Path::Class::Dir->new($temp_dir);

# Test successful removal of an empty directory
my $result = eval { $dir->rmtree(); };
if ($@) { fail('rmtree crashed: ' . $@); } else { ok(! -e $temp_dir, 'Empty directory removed successfully'); }

# Create a temporary directory with a file
my $temp_dir_with_file = tempdir(CLEANUP => 1);
my $dir_with_file = Path::Class::Dir->new($temp_dir_with_file);
my $file = Path::Class::File->new($temp_dir_with_file, 'test.txt');
$file->touch;

# Test successful removal of a directory with a file
$result = eval { $dir_with_file->rmtree(); };
if ($@) { fail('rmtree crashed: ' . $@); } else { ok(! -e $temp_dir_with_file, 'Directory with file removed successfully'); }

# Test removal of a non-existent directory
my $non_existent_dir = Path::Class::Dir->new('non_existent_dir');
$result = eval { $non_existent_dir->rmtree(); };
if ($@) { pass('rmtree failed for non-existent directory'); } else { fail('rmtree succeeded for non-existent directory'); }

done_testing();
