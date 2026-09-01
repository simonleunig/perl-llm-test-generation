use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::subdir"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'subdir is defined'); }

# Create a temporary directory
my $temp_dir = tempdir();
my $dir = Path::Class::Dir->new($temp_dir);

# Test case: Create a subdirectory
my $result = eval { $dir->subdir('subdir') };
if ($@) { fail('subdir crashed: ' . $@); } else { ok(defined $result, 'subdir returns result'); }

# Test case: Create a subdirectory with multiple components
$result = eval { $dir->subdir('subdir', 'subsubdir') };
if ($@) { fail('subdir crashed: ' . $@); } else { ok(defined $result, 'subdir returns result with multiple components'); }

# Test case: Create a subdirectory with no components
$result = eval { $dir->subdir() };
if ($@) { fail('subdir crashed: ' . $@); } else { ok(defined $result, 'subdir returns result with no components'); }

# Clean up resources
# AFTER LAST PASS: END { rmdir($temp_dir) if defined $temp_dir; }

done_testing();
