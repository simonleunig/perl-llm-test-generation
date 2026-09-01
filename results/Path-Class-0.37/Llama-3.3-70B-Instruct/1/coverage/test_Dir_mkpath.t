use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::mkpath"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'mkpath is defined'); }

# Create a temporary directory
my $temp_dir = tempdir();

# Test case: Create a directory that does not exist
my $dir = Path::Class::Dir->new($temp_dir, 'test_dir');
my $result = eval { $dir->mkpath() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }

# Test case: Create a directory that already exists
$result = eval { $dir->mkpath() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for existing directory'); }

# Test case: Create a directory with a depth of 2
$dir = Path::Class::Dir->new($temp_dir, 'test_dir', 'sub_dir');
$result = eval { $dir->mkpath() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for nested directory'); }

# Clean up resources
# AFTER LAST PASS: END { rmdir($temp_dir . '/test_dir/sub_dir') if -d $temp_dir . '/test_dir/sub_dir'; }
# AFTER LAST PASS: END { rmdir($temp_dir . '/test_dir') if -d $temp_dir . '/test_dir'; }
# AFTER LAST PASS: END { rmdir($temp_dir) if -d $temp_dir; }

done_testing();
