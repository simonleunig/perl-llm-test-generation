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
my ($fh, $filename) = eval { $temp_dir->tempfile() };
if ($@) { fail('tempfile function crashed: ' . $@); } else { ok(defined $fh, 'tempfile function returns filehandle'); }

# Check if file exists
my $file_exists = eval { -e $filename };
if ($@) { fail('File existence check crashed: ' . $@); } else { ok($file_exists, 'Temporary file exists'); }

# Clean up
eval { undef $fh; unlink $filename };
if ($@) { fail('Failed to clean up temporary file: ' . $@); }

# Test tempfile function with invalid directory
my $invalid_dir = eval { Path::Class::Dir->new('/non/existent/directory') };
if ($@) { fail('Failed to create invalid directory object: ' . $@); } else { ok(defined $invalid_dir, 'Invalid directory object created'); }

my ($invalid_fh, $invalid_filename) = eval { $invalid_dir->tempfile() };
if ($@) { 
    like($@, qr/No such file or directory/, 'tempfile function with invalid directory throws expected error');
} else { fail('tempfile function with invalid directory did not throw error'); }

done_testing();
