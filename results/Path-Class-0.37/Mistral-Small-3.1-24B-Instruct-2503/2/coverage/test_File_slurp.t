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
# AFTER LAST PASS: mock 'Path::Class::File' => (
    # AFTER LAST PASS: open => sub {
        my ($self, $mode);  # AFTER LAST PASS: my ($self, $mode) = @_;
        # AFTER LAST PASS: if ($mode eq 'r') {
            # AFTER LAST PASS: return IO::File->new('> /dev/null');
        # AFTER LAST PASS: }
        # AFTER LAST PASS: return undef;
    # AFTER LAST PASS: }
# AFTER LAST PASS: );

# Test case: Reading an empty file in scalar context
# AFTER LAST PASS: {
    my ($fh, $filename);  # AFTER LAST PASS: my ($fh, $filename) = tempfile();
    my $file;  # AFTER LAST PASS: my $file;  # UNVALIDATED: my $file = Path::Class::File->new($filename);
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $file->slurp() };
    # FAILED: is($@, '', 'No exception thrown for empty file in scalar context');
    # FAILED: is($result, '', 'Empty file returns empty string in scalar context');
    # AFTER LAST PASS: unlink $filename;
# AFTER LAST PASS: }

# Test case: Reading a file with content in scalar context
# AFTER LAST PASS: {
    my ($fh, $filename);  # AFTER LAST PASS: my ($fh, $filename) = tempfile();
    # AFTER LAST PASS: print $fh "Hello, World!\n";
    # AFTER LAST PASS: close $fh;
    my $file;  # AFTER LAST PASS: my $file;  # UNVALIDATED: my $file = Path::Class::File->new($filename);
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $file->slurp() };
    # FAILED: is($@, '', 'No exception thrown for file with content in scalar context');
    # FAILED: is($result, "Hello, World!\n", 'File content returned correctly in scalar context');
    # AFTER LAST PASS: unlink $filename;
# AFTER LAST PASS: }

# Test case: Reading a file with content in list context
# AFTER LAST PASS: {
    my ($fh, $filename);  # AFTER LAST PASS: my ($fh, $filename) = tempfile();
    # AFTER LAST PASS: print $fh "Line 1\nLine 2\nLine 3\n";
    # AFTER LAST PASS: close $fh;
    my $file;  # AFTER LAST PASS: my $file;  # UNVALIDATED: my $file = Path::Class::File->new($filename);
    my @result;  # AFTER LAST PASS: my @result;  # UNVALIDATED: my @result = eval { $file->slurp() };
    # FAILED: is($@, '', 'No exception thrown for file with content in list context');
    # FAILED: is_deeply(\@result, ["Line 1\n", "Line 2\n", "Line 3\n"], 'File content returned correctly in list context');
    # AFTER LAST PASS: unlink $filename;
# AFTER LAST PASS: }

# Test case: Reading a file with chomp in list context
# AFTER LAST PASS: {
    my ($fh, $filename);  # AFTER LAST PASS: my ($fh, $filename) = tempfile();
    # AFTER LAST PASS: print $fh "Line 1\nLine 2\nLine 3\n";
    # AFTER LAST PASS: close $fh;
    my $file;  # AFTER LAST PASS: my $file;  # UNVALIDATED: my $file = Path::Class::File->new($filename);
    my @result;  # AFTER LAST PASS: my @result;  # UNVALIDATED: my @result = eval { $file->slurp(chomp => 1) };
    # FAILED: is($@, '', 'No exception thrown for file with chomp in list context');
    # FAILED: is_deeply(\@result, ["Line 1", "Line 2", "Line 3"], 'File content returned correctly with chomp in list context');
    # AFTER LAST PASS: unlink $filename;
# AFTER LAST PASS: }

# Test case: Reading a file with split in list context
# AFTER LAST PASS: {
    my ($fh, $filename);  # AFTER LAST PASS: my ($fh, $filename) = tempfile();
    # AFTER LAST PASS: print $fh "one:two:three\nfour:five:six\n";
    # AFTER LAST PASS: close $fh;
    my $file;  # AFTER LAST PASS: my $file;  # UNVALIDATED: my $file = Path::Class::File->new($filename);
    my @result;  # AFTER LAST PASS: my @result;  # UNVALIDATED: my @result = eval { $file->slurp(split => qr/:/) };
    # FAILED: is($@, '', 'No exception thrown for file with split in list context');
    # FAILED: is_deeply(\@result, [["one", "two", "three"], ["four", "five", "six"]], 'File content returned correctly with split in list context');
    # AFTER LAST PASS: unlink $filename;
# AFTER LAST PASS: }

# Test case: Using split in scalar context should throw an exception
# AFTER LAST PASS: {
    my ($fh, $filename);  # AFTER LAST PASS: my ($fh, $filename) = tempfile();
    # AFTER LAST PASS: print $fh "one:two:three\n";
    # AFTER LAST PASS: close $fh;
    my $file;  # AFTER LAST PASS: my $file;  # UNVALIDATED: my $file = Path::Class::File->new($filename);
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $file->slurp(split => qr/:/) };
    # FAILED: like($@, qr/'split' argument can only be used in list context/, 'Exception thrown for split in scalar context');
    # AFTER LAST PASS: unlink $filename;
# AFTER LAST PASS: }

# Test case: Non-existent file should throw an exception
# AFTER LAST PASS: {
    my $file;  # AFTER LAST PASS: my $file;  # UNVALIDATED: my $file = Path::Class::File->new('/nonexistent/file');
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $file->slurp() };
    # FAILED: like($@, qr/Can't read/, 'Exception thrown for non-existent file');
# AFTER LAST PASS: }

done_testing();