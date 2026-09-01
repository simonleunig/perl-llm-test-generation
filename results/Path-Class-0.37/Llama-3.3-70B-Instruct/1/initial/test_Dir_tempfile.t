use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::tempfile"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'tempfile is defined'); }

# Create a temporary directory
my $temp_dir = eval { Path::Class::Dir->new(tempdir()) };
if ($@) { fail('Failed to create temporary directory: ' . $@); } else { ok(defined $temp_dir, 'Temporary directory created'); }

# Test tempfile function
my $result = eval { $temp_dir->tempfile() };
if ($@) { fail('tempfile function crashed: ' . $@); } else { ok(defined $result, 'tempfile function returns result'); }

# Test tempfile function with arguments
my $result_with_args = eval { $temp_dir->tempfile('test_file') };
if ($@) { fail('tempfile function with arguments crashed: ' . $@); } else { ok(defined $result_with_args, 'tempfile function with arguments returns result'); }

# Test error handling
my $invalid_dir = eval { Path::Class::Dir->new('invalid_directory') };
if ($@) { fail('Failed to create invalid directory: ' . $@); } else { ok(defined $invalid_dir, 'Invalid directory created'); }
my $error_result = eval { $invalid_dir->tempfile() };
if ($@) { ok($@, 'tempfile function handles invalid directory'); } else { fail('tempfile function did not handle invalid directory'); }

done_testing();
