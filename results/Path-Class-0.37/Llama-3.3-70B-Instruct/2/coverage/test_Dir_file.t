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
my $temp_dir = tempdir();
my $dir = Path::Class::Dir->new($temp_dir);

# Test case: Create a new file object
my $result = eval { $dir->file('test_file.txt') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }

# Test case: Check if the returned object is of the correct class
$result = eval { $dir->file('test_file.txt') };
if ($@) { fail('Function crashed: ' . $@); } else { ok($result->isa('Path::Class::File'), 'Returned object is of class Path::Class::File'); }

# Test case: Check if the file object has the correct path
$result = eval { $dir->file('test_file.txt') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result->stringify, File::Spec->catdir($temp_dir, 'test_file.txt'), 'File object has the correct path'); }

# Clean up resources
# AFTER LAST PASS: END { rmdir $temp_dir if defined $temp_dir };

done_testing();
