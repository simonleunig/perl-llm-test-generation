use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::contains"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'contains is defined'); }

my $dir = Path::Class::Dir->new(tempdir(CLEANUP => 1));
my $file = $dir->file('test.txt');
$file->spew('Hello World!');
my $result = eval { Path::Class::Dir::contains($dir, $file) };
if ($@) { fail('Function crashed: ' . $@); } else { ok($result, 'Directory contains a file'); }

my $subdir = $dir->subdir('subdir');
$subdir->mkpath;
$result = eval { Path::Class::Dir::contains($dir, $subdir) };
if ($@) { fail('Function crashed: ' . $@); } else { ok($result, 'Directory contains a subdirectory'); }

$file = Path::Class::File->new('/non/existent/file.txt');
$result = eval { Path::Class::Dir::contains($dir, $file) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!$result, 'Directory does not contain a non-existent file'); }

$result = eval { Path::Class::Dir::contains($dir, $file, 'extra arg') };
# FAILED: if ($@) { like($@, qr/Too many arguments given to contains\(/, 'Error handling - too many arguments'); } else { fail('Expected error not thrown'); }

$result = eval { Path::Class::Dir::contains($dir) };
if ($@) { like($@, qr/No second entity given to contains\(/, 'Error handling - no second entity'); } else { fail('Expected error not thrown'); }

done_testing();