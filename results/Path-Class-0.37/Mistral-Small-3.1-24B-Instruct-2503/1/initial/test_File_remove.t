use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::remove"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'remove is defined'); }

# Test case: File does not exist
{
    my ($fh, $filename) = tempfile();
    close($fh);
    unlink($filename);  # Ensure the file does not exist

    my $file = Path::Class::File->new($filename);
    my $result = eval { $file->remove() };
    if ($@) { fail('Function crashed: ' . $@); } else { ok($result, 'File does not exist, remove returns true'); }
}

# Test case: File exists and is successfully removed
{
    my ($fh, $filename) = tempfile();
    close($fh);

    my $file = Path::Class::File->new($filename);
    my $result = eval { $file->remove() };
    if ($@) { fail('Function crashed: ' . $@); } else { ok($result, 'File exists and is successfully removed'); }

    # Verify the file is actually removed
    ok(!-e $filename, 'File is removed from the filesystem');
}

# Test case: File is a directory (should not be handled by this function)
{
    my $dir = tempdir(CLEANUP => 1);
    my $file = Path::Class::File->new($dir);

    my $result = eval { $file->remove() };
    if ($@) { fail('Function crashed: ' . $@); } else { ok(!$result, 'File is a directory, remove returns false'); }
}

# Test case: File is locked or in use by another process
{
    my ($fh, $filename) = tempfile();
    open(my $lock_fh, '>', $filename) or die "Cannot open file: $!";
    flock($lock_fh, LOCK_EX) or die "Cannot lock file: $!";

    my $file = Path::Class::File->new($filename);
    my $result = eval { $file->remove() };
    if ($@) { fail('Function crashed: ' . $@); } else { ok(!$result, 'File is locked, remove returns false'); }

    close($lock_fh);
    unlink($filename);  # Clean up the file
}

# Test case: File system is read-only
{
    my $dir = tempdir(CLEANUP => 1);
    my $filename = File::Spec->catfile($dir, 'readonly_file.txt');
    open(my $fh, '>', $filename) or die "Cannot open file: $!";
    close($fh);

    # Mock the unlink function to simulate a read-only filesystem
    mock 'CORE::GLOBAL::unlink' => sub { return 0; };

    my $file = Path::Class::File->new($filename);
    my $result = eval { $file->remove() };
    if ($@) { fail('Function crashed: ' . $@); } else { ok(!$result, 'File system is read-only, remove returns false'); }

    unlink($filename);  # Clean up the file
}

done_testing();
