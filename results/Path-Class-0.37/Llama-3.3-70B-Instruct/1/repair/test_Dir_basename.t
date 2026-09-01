use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::basename"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'basename is defined'); }

# Test case: Empty directory path
my $dir = Path::Class::Dir->new('');
my $result = eval { $dir->basename() };
if ($@) { fail('basename crashed on empty path: ' . $@); } else { is($result, '', 'basename returns empty string on empty path'); }

# Test case: Valid directory path
$dir = Path::Class::Dir->new('path/to/directory');
$result = eval { $dir->basename() };
if ($@) { fail('basename crashed on valid path: ' . $@); } else { is($result, 'directory', 'basename returns last directory name on valid path'); }

# Test case: Directory path with multiple components
$dir = Path::Class::Dir->new('path/to/multiple/directories');
$result = eval { $dir->basename() };
if ($@) { fail('basename crashed on path with multiple components: ' . $@); } else { is($result, 'directories', 'basename returns last directory name on path with multiple components'); }

# Test case: Invalid directory path (not a Path::Class::Dir object)
my $invalid_dir = 'not a Path::Class::Dir object';
$result = eval { $invalid_dir->basename() };
if ($@) { ok(1, 'basename crashes on invalid path'); } else { fail('basename did not crash on invalid path'); }

done_testing();
