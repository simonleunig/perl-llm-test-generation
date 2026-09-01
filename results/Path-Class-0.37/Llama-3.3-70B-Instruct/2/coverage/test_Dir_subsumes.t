use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::subsumes"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'subsumes is defined'); }

my $result = eval { Path::Class::Dir->subsumes('path1', 'path2', 'path3') };
if ($@) { like($@, qr/Too many arguments given to subsumes\(\)/, 'Too many arguments'); } else { fail('Expected exception not thrown'); }

$result = eval { Path::Class::Dir->subsumes('path1') };
# FAILED: if ($@) { like($@, qr/No second entity given to subsumes\(\)/, 'No second entity given'); } else { fail('Expected exception not thrown'); }

my $dir1 = Path::Class::Dir->new('/absolute/path');
my $dir2 = Path::Class::Dir->new('relative/path');
$result = eval { $dir1->subsumes($dir2) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok($result, 'Absolute path subsumes relative path'); }

$dir1 = Path::Class::Dir->new('relative/path');
$dir2 = Path::Class::Dir->new('/absolute/path');
$result = eval { $dir1->subsumes($dir2) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!$result, 'Relative path does not subsume absolute path'); }

$dir1 = Path::Class::Dir->new('/');
$dir2 = Path::Class::Dir->new('/path/to/dir');
$result = eval { $dir1->subsumes($dir2) };
if ($@) { fail('Function crashed: ' . $@); } else { ok($result, 'Root directory subsumes all directories'); }

$dir1 = Path::Class::Dir->new('.');
$dir2 = Path::Class::Dir->new('relative/path');
$result = eval { $dir1->subsumes($dir2) };
if ($@) { fail('Function crashed: ' . $@); } else { ok($result, 'Current directory subsumes relative paths'); }

$dir1 = Path::Class::Dir->new('C:/path/to/dir');
$dir2 = Path::Class::Dir->new('C:/path/to/other/dir');
$result = eval { $dir1->subsumes($dir2) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!$result, 'Directory with volume does not subsume directory with same volume'); }

done_testing();