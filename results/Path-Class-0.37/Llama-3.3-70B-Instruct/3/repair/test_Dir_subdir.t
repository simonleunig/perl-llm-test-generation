use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::subdir"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'subdir is defined'); }

# Create a temporary directory for testing
my $temp_dir = tempdir();
my $dir = Path::Class::Dir->new($temp_dir);

# Test case 1: Create a subdirectory with a valid name
my $result = eval { $dir->subdir('valid_subdir') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for valid subdirectory'); }

# Test case 2: Create a subdirectory with an invalid name (contains invalid characters)
$result = eval { $dir->subdir('invalid?subdir') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for invalid subdirectory'); }

# Test case 3: Create a subdirectory with a name that is too long
$result = eval { $dir->subdir('a' x 256) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for long subdirectory'); }

# Test case 4: Create a subdirectory with no name
$result = eval { $dir->subdir('') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for empty subdirectory'); }

# Clean up resources
END { rmdir $temp_dir if defined $temp_dir; }

done_testing();
