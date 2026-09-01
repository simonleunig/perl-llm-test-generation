use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::open"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'open is defined'); }

# Create a temporary directory
my $temp_dir = tempdir();
my $dir = Path::Class::Dir->new($temp_dir);

# Test case: Open a directory that exists
my $result = eval { $dir->open() };
if ($@) { fail('Open crashed: ' . $@); } else { ok(defined $result, 'Open returns result'); }

# Test case: Open a directory that does not exist
my $non_existent_dir = Path::Class::Dir->new('non_existent_dir');
my $non_existent_result = eval { $non_existent_dir->open() };
if ($@) { ok($@, 'Open throws exception for non-existent directory'); } else { fail('Open did not throw exception for non-existent directory'); }

# Test case: Open a directory that is not readable
my $unreadable_dir = Path::Class::Dir->new($temp_dir);
# Make the directory unreadable
eval { chmod 000, $unreadable_dir->stringify() };
my $unreadable_result = eval { $unreadable_dir->open() };
if ($@) { ok($@, 'Open throws exception for unreadable directory'); } else { fail('Open did not throw exception for unreadable directory'); }
# Make the directory readable again
eval { chmod 0755, $unreadable_dir->stringify() };

# Clean up resources
eval { rmdir($temp_dir) };

done_testing();
