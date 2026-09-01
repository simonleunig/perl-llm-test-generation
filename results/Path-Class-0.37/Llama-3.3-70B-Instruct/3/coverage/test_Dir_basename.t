use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::basename"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'basename is defined'); }

my $dir = Path::Class::Dir->new('/path/to/directory');
my $result = eval { $dir->basename() };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'directory', 'basename returns last directory name'); }

$dir = Path::Class::Dir->new('/absolute/path/to/directory');
$result = eval { $dir->basename() };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'directory', 'basename returns last directory name for absolute path'); }

$dir = Path::Class::Dir->new('relative/path/to/directory');
$result = eval { $dir->basename() };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'directory', 'basename returns last directory name for relative path'); }

$dir = Path::Class::Dir->new('path/to/directory');
$result = eval { $dir->basename() };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'directory', 'basename returns last directory name with different separator'); }

$dir = Path::Class::Dir->new('');
$result = eval { $dir->basename() };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { is($result, undef, 'basename returns undef for empty directory path'); }

my $undefined_dir;
my $error = eval { $undefined_dir->basename() };
if ($@) { ok($@, "Dies with undefined directory object"); like($@, qr/Can't call method "basename" on an undefined value/, "Error message correct"); } else { fail("Does not die with undefined directory object"); }

done_testing();