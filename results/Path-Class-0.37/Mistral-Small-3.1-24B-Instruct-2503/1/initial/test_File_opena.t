use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::opena"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'opena is defined'); }

# Mocking IO::File
mock 'IO::File', open => sub {
    my ($class, $mode, $file) = @_;
    if ($mode eq 'a') {
        return bless {}, $class;
    } else {
        return undef;
    }
};

# Test case: Successful file open in append mode
{
    my ($fh, $filename) = tempfile();
    my $file = Path::Class::File->new($filename);
    my $result = eval { $file->opena() };
    if ($@) {
        fail('Function crashed: ' . $@);
    } else {
        ok(defined $result, 'File opened successfully in append mode');
        isa_ok($result, 'IO::File', 'Returned object is an IO::File');
    }
    unlink $filename;
}

# Test case: File open fails due to invalid mode
{
    my ($fh, $filename) = tempfile();
    my $file = Path::Class::File->new($filename);
    mock 'IO::File', open => sub {
        return undef;
    };
    my $result = eval { $file->opena() };
    if ($@) {
        like($@, qr/Can't append to .*$filename/, 'Error message is correct');
    } else {
        fail('Function did not throw an exception');
    }
    unlink $filename;
}

# Test case: File open fails due to permission issues
{
    my ($fh, $filename) = tempfile();
    my $file = Path::Class::File->new($filename);
    mock 'IO::File', open => sub {
        $! = 13;  # Permission denied
        return undef;
    };
    my $result = eval { $file->opena() };
    if ($@) {
        like($@, qr/Can't append to .*$filename: Permission denied/, 'Error message is correct');
    } else {
        fail('Function did not throw an exception');
    }
    unlink $filename;
}

# Test case: File open fails due to non-existent file
{
    my $filename = File::Spec->catfile(tempdir(), 'non_existent_file.txt');
    my $file = Path::Class::File->new($filename);
    mock 'IO::File', open => sub {
        $! = 2;  # No such file or directory
        return undef;
    };
    my $result = eval { $file->opena() };
    if ($@) {
        like($@, qr/Can't append to .*$filename: No such file or directory/, 'Error message is correct');
    } else {
        fail('Function did not throw an exception');
    }
}

done_testing();
