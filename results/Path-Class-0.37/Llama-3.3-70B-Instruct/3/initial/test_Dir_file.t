use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::file"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'file is defined'); }

# Create a temporary directory
my $temp_dir = tempdir(CLEANUP => 1);

# Create a Path::Class::Dir object
my $dir = Path::Class::Dir->new($temp_dir);

# Test case: Create a file object with a valid file name
my $result = eval { $dir->file('test_file.txt') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for valid file name'); }

# Test case: Create a file object with an invalid file name (empty string)
$result = eval { $dir->file('') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for empty file name'); }

# Test case: Create a file object with a file name containing invalid characters
$result = eval { $dir->file('test/file.txt') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for file name with invalid characters'); }

# Test case: Create a file object without a file name (should return undef)
$result = eval { $dir->file() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result, 'Function returns undef for no file name'); }

done_testing();
