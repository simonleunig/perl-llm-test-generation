use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::remove"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'remove is defined'); }

# Create a temporary directory
my $temp_dir = tempdir();

# Test successful removal of an empty directory
my $dir = Path::Class::Dir->new($temp_dir);
my $result = eval { $dir->remove() };
if ($@) { fail('Remove crashed: ' . $@); } else { ok(! -d $temp_dir, 'Empty directory removed successfully'); }

# Test removal of a non-empty directory
my $non_empty_dir = tempdir();
my $file = Path::Class::File->new($non_empty_dir, 'test.txt');
$file->touch();
my $non_empty_result = eval { Path::Class::Dir->new($non_empty_dir)->remove() };
if ($@) { ok($@, 'Non-empty directory removal failed as expected'); } else { fail('Non-empty directory removed unexpectedly'); }

# Test removal of a non-existent directory
my $non_existent_dir = tempdir();
$rmdir($non_existent_dir) or die $!;
my $non_existent_result = eval { Path::Class::Dir->new($non_existent_dir)->remove() };
if ($@) { ok($@, 'Non-existent directory removal failed as expected'); } else { fail('Non-existent directory removed unexpectedly'); }

done_testing();
