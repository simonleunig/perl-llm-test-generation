use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::openr"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'openr is defined'); }

# Test case: File exists and is readable
{
    my ($fh, $filename) = tempfile();
    print $fh "Test content";
    close $fh;

    my $file = Path::Class::File->new($filename);
    my $result = eval { $file->openr() };
    if ($@) {
        fail('Function crashed: ' . $@);
    } else {
        ok(defined $result, 'File opened successfully');
        isa_ok($result, 'IO::File', 'Returned object is an IO::File');
        is($result->getline(), 'Test content', 'File content is correct');
        $result->close();
    }
}

# Test case: File does not exist
{
    my $filename = File::Spec->catfile(tempdir(), 'nonexistent_file.txt');
    my $file = Path::Class::File->new($filename);
    my $result = eval { $file->openr() };
    if ($@) {
        like($@, qr/Can't read $filename: No such file or directory/, 'Error message is correct');
    } else {
        fail('Function did not throw an exception');
    }
}

# Test case: File is not readable (permissions issue)
{
    my $dir = tempdir();
    my $filename = File::Spec->catfile($dir, 'unreadable_file.txt');
    open(my $fh, '>', $filename) or die "Cannot create file: $!";
    close $fh;
    chmod 0000, $filename;  # Make the file unreadable

    my $file = Path::Class::File->new($filename);
    my $result = eval { $file->openr() };
    if ($@) {
        like($@, qr/Can't read $filename: Permission denied/, 'Error message is correct');
    } else {
        fail('Function did not throw an exception');
    }
}

# Test case: Invalid file path
{
    my $invalid_path = 'invalid/path/to/file.txt';
    my $file = Path::Class::File->new($invalid_path);
    my $result = eval { $file->openr() };
    if ($@) {
        like($@, qr/Can't read $invalid_path: No such file or directory/, 'Error message is correct');
    } else {
        fail('Function did not throw an exception');
    }
}

done_testing();