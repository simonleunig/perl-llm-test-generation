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

# Test case 1: Normal directory path
my $dir = Path::Class::Dir->new('/path/to/directory');
my $result = eval { $dir->basename };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'directory', 'basename returns last directory name'); }

# Test case 2: Absolute directory path
$dir = Path::Class::Dir->new('/absolute/path/to/directory');
$result = eval { $dir->basename };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'directory', 'basename returns last directory name for absolute path'); }

# Test case 3: Relative directory path
$dir = Path::Class::Dir->new('relative/path/to/directory');
$result = eval { $dir->basename };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'directory', 'basename returns last directory name for relative path'); }

# Test case 4: Directory path with different separator
$dir = Path::Class::Dir->new('path\\to\\directory');
$result = eval { $dir->basename };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'directory', 'basename returns last directory name with different separator'); }

# Test case 5: Empty directory path
$dir = Path::Class::Dir->new('');
$result = eval { $dir->basename };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, undef, 'basename returns undef for empty directory path'); }

# Test case 6: Undefined directory object
my $undefined_dir;
$result = eval { $undefined_dir->basename };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result, 'basename returns undef for undefined directory object'); }

done_testing();
