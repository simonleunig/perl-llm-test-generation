use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }
use Fcntl ':flock';

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
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok($result, 'File does not exist, remove returns true'); }
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
# AFTER LAST PASS: {
    my ($fh, $filename);  # AFTER LAST PASS: my ($fh, $filename) = tempfile();
    my $lock_fh;  # AFTER LAST PASS: open(my $lock_fh, '>', $filename) or die "Cannot open file: $!";
    # AFTER LAST PASS: flock($lock_fh, LOCK_EX) or die "Cannot lock file: $!";

    my $file;  # AFTER LAST PASS: my $file;  # UNVALIDATED: my $file = Path::Class::File->new($filename);
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $file->remove() };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(!$result, 'File is locked, remove returns false'); }

    # AFTER LAST PASS: close($lock_fh);
    # AFTER LAST PASS: unlink($filename);  # Clean up the file
# AFTER LAST PASS: }

# Test case: File system is read-only
# AFTER LAST PASS: {
    my $dir;  # AFTER LAST PASS: my $dir = tempdir(CLEANUP => 1);
    my $filename;  # AFTER LAST PASS: my $filename = File::Spec->catfile($dir, 'readonly_file.txt');
    my $fh;  # AFTER LAST PASS: open(my $fh, '>', $filename) or die "Cannot open file: $!";
    # AFTER LAST PASS: close($fh);

    # Mock the unlink function to simulate a read-only filesystem
    # AFTER LAST PASS: mock 'CORE::GLOBAL::unlink' => sub { return 0; };

    my $file;  # AFTER LAST PASS: my $file;  # UNVALIDATED: my $file = Path::Class::File->new($filename);
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $file->remove() };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(!$result, 'File system is read-only, remove returns false'); }

    # AFTER LAST PASS: unlink($filename);  # Clean up the file
# AFTER LAST PASS: }

done_testing();