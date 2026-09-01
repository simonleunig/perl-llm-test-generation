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

# Test case: Create a new directory object
my $dir = eval { Path::Class::Dir->new('test_dir') };
if ($@) { fail('Directory creation crashed: ' . $@); } else { ok(defined $dir, 'Directory object created'); }

# Test case: Create a subdirectory
my $subdir = eval { $dir->subdir('sub_test_dir') };
if ($@) { fail('Subdirectory creation crashed: ' . $@); } else { ok(defined $subdir, 'Subdirectory object created'); }

# Test case: Check if subdir returns a Path::Class::Dir object
my $is_dir_object = eval { $subdir->isa('Path::Class::Dir') };
if ($@) { fail('isa check crashed: ' . $@); } else { ok($is_dir_object, 'Subdirectory is a Path::Class::Dir object'); }

# Test case: Create a subdirectory with multiple levels
my $deep_subdir = eval { $dir->subdir('level1', 'level2', 'level3') };
if ($@) { fail('Deep subdirectory creation crashed: ' . $@); } else { ok(defined $deep_subdir, 'Deep subdirectory object created'); }

# Test case: Check if deep subdir returns a Path::Class::Dir object
my $is_deep_dir_object = eval { $deep_subdir->isa('Path::Class::Dir') };
if ($@) { fail('isa check crashed: ' . $@); } else { ok($is_deep_dir_object, 'Deep subdirectory is a Path::Class::Dir object'); }

# Clean up
my $temp_dir = tempdir(CLEANUP => 1);
my $dir_obj = eval { Path::Class::Dir->new($temp_dir) };
if ($@) { fail('Temporary directory creation crashed: ' . $@); }
else {
    # Remove the temporary directory
    eval { $dir_obj->rmdir() };
    if ($@) { fail('Temporary directory removal crashed: ' . $@); }
}

done_testing();
