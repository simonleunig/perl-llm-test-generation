use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::traverse"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'traverse is defined'); }

# Create a temporary directory
my $temp_dir = tempdir();

# Create a Path::Class::Dir object
my $dir = Path::Class::Dir->new($temp_dir);

# Test case: traverse with a callback function
my $result = eval { $dir->traverse(sub { 1 }, 'arg1', 'arg2') };
if ($@) { fail('traverse crashed: ' . $@); } else { ok(defined $result, 'traverse returns result'); }

# Test case: traverse with an empty directory
my $empty_dir = tempdir();
my $empty_dir_obj = Path::Class::Dir->new($empty_dir);
$result = eval { $empty_dir_obj->traverse(sub { 1 }, 'arg1', 'arg2') };
if ($@) { fail('traverse on empty directory crashed: ' . $@); } else { ok(defined $result, 'traverse on empty directory returns result'); }

# Test case: traverse with a non-existent directory
my $non_existent_dir = Path::Class::Dir->new('non_existent_dir');
$result = eval { $non_existent_dir->traverse(sub { 1 }, 'arg1', 'arg2') };
if ($@) { fail('traverse on non-existent directory crashed: ' . $@); } else { ok(!defined $result, 'traverse on non-existent directory returns undef'); }

# Clean up resources
END { rmdir $temp_dir; rmdir $empty_dir; }

done_testing();
