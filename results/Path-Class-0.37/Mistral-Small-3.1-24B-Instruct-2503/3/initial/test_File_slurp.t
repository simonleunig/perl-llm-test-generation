use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::slurp"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'slurp is defined'); }

# Mocking dependencies
mock 'Path::Class::File' => (
    open => sub {
        my ($self, $mode) = @_;
        if ($mode eq 'r') {
            return IO::File->new('> /dev/null');
        }
        return undef;
    }
);

# Test case: Reading an empty file in scalar context
{
    my ($fh, $filename) = tempfile();
    my $file = Path::Class::File->new($filename);
    my $result = eval { $file->slurp() };
    is($@, '', 'No exception thrown for empty file in scalar context');
    is($result, '', 'Empty file returns empty string in scalar context');
}

# Test case: Reading a file with content in scalar context
{
    my ($fh, $filename) = tempfile();
    print $fh "Hello, World!\n";
    close $fh;
    my $file = Path::Class::File->new($filename);
    my $result = eval { $file->slurp() };
    is($@, '', 'No exception thrown for file with content in scalar context');
    is($result, "Hello, World!\n", 'File content returned correctly in scalar context');
}

# Test case: Reading a file with content in list context
{
    my ($fh, $filename) = tempfile();
    print $fh "Line 1\nLine 2\nLine 3\n";
    close $fh;
    my $file = Path::Class::File->new($filename);
    my @result = eval { $file->slurp() };
    is($@, '', 'No exception thrown for file with content in list context');
    is_deeply(\@result, ["Line 1\n", "Line 2\n", "Line 3\n"], 'File content returned correctly in list context');
}

# Test case: Reading a file with chomp in list context
{
    my ($fh, $filename) = tempfile();
    print $fh "Line 1\nLine 2\nLine 3\n";
    close $fh;
    my $file = Path::Class::File->new($filename);
    my @result = eval { $file->slurp(chomp => 1) };
    is($@, '', 'No exception thrown for file with chomp in list context');
    is_deeply(\@result, ["Line 1", "Line 2", "Line 3"], 'File content returned correctly with chomp in list context');
}

# Test case: Reading a file with split in list context
{
    my ($fh, $filename) = tempfile();
    print $fh "one:two:three\nfour:five:six\n";
    close $fh;
    my $file = Path::Class::File->new($filename);
    my @result = eval { $file->slurp(split => qr/:/) };
    is($@, '', 'No exception thrown for file with split in list context');
    is_deeply(\@result, [["one", "two", "three"], ["four", "five", "six"]], 'File content returned correctly with split in list context');
}

# Test case: Using split in scalar context should throw an exception
{
    my ($fh, $filename) = tempfile();
    print $fh "one:two:three\n";
    close $fh;
    my $file = Path::Class::File->new($filename);
    my $result = eval { $file->slurp(split => qr/:/) };
    like($@, qr/'split' argument can only be used in list context/, 'Exception thrown for split in scalar context');
}

# Test case: Non-existent file should throw an exception
{
    my $file = Path::Class::File->new('/nonexistent/file');
    my $result = eval { $file->slurp() };
    like($@, qr/Can't read/, 'Exception thrown for non-existent file');
}

# Clean up temporary files
unlink $filename if defined $filename;

done_testing();
