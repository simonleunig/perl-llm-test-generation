use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::remove"} };
if ($@) { fail("Symbol check crashed: $@"); } else { ok($symbol_check, 'remove is defined'); }

my $temp_dir = tempdir(CLEANUP => 1);
my $file = Path::Class::File->new($temp_dir, 'non_existent_file.txt');
my $result = eval { $file->remove() };
if ($@) { fail("Remove non-existent file crashed: $@"); } else { ok(!$result, 'Remove non-existent file returns false'); }

my ($fh, $filename) = tempfile(UNLINK => 1);
my $existing_file = Path::Class::File->new($filename);
$result = eval { $existing_file->remove() };
if ($@) { fail("Remove existing file crashed: $@"); } else { ok($result, 'Remove existing file returns true'); }

my $temp_subdir = tempdir(CLEANUP => 1);
my $dir_file = Path::Class::File->new($temp_subdir);
$result = eval { $dir_file->remove() };
if ($@) { fail("Remove directory crashed: $@"); } else { ok(!$result, 'Remove directory returns false'); }

done_testing();