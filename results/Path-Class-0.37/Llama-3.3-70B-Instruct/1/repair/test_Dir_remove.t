use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::remove"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'remove is defined'); }

my $temp_dir = tempdir();
my $dir = Path::Class::Dir->new($temp_dir);
my $result = eval { $dir->remove() };
if ($@) { fail('Remove crashed: ' . $@); } else { ok(! -d $temp_dir, 'Empty directory removed successfully'); }

my $non_empty_dir = tempdir();
my $file = Path::Class::File->new($non_empty_dir, 'test.txt');
$file->touch();
my $non_empty_result = eval { Path::Class::Dir->new($non_empty_dir)->remove() };
if ($@) { ok($@, 'Non-empty directory removal failed as expected'); } else { fail('Non-empty directory removed unexpectedly'); }

my $non_existent_dir = tempdir();
$rmdir($non_existent_dir) or die $!;
my $non_existent_result = eval { Path::Class::Dir->new($non_existent_dir)->remove() };
if ($@) { ok($@, 'Non-existent directory removal failed as expected'); } else { fail('Non-existent directory removed unexpectedly'); }

done_testing();