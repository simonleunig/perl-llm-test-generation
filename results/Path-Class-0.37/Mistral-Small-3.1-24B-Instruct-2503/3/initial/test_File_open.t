use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::open"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'open is defined'); }

# Mock IO::File->new
mock 'IO::File', new => sub {
    my ($class, $file, $mode) = @_;
    if ($file eq 'nonexistent_file') {
        return undef;
    } elsif ($file eq 'invalid_mode_file') {
        return undef;
    } else {
        return bless {}, 'IO::File';
    }
};

# Test case: Successful file open
{
    my ($fh, $filename) = tempfile();
    my $result = eval { Path::Class::File::open($filename, 'w') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(defined $result, 'File opened successfully');
        isa_ok($result, 'IO::File', 'Returned object is an IO::File');
    }
    unlink $filename;
}

# Test case: File does not exist
{
    my $result = eval { Path::Class::File::open('nonexistent_file', 'r') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(!defined $result, 'File does not exist, returns undef');
        is($!, 'No such file or directory', 'Error message is correct');
    }
}

# Test case: Invalid mode
{
    my ($fh, $filename) = tempfile();
    my $result = eval { Path::Class::File::open($filename, 'invalid_mode') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(!defined $result, 'Invalid mode, returns undef');
        is($!, 'Invalid argument', 'Error message is correct');
    }
    unlink $filename;
}

# Test case: File is a directory
{
    my $dir = tempdir(CLEANUP => 1);
    my $result = eval { Path::Class::File::open($dir, 'r') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(!defined $result, 'File is a directory, returns undef');
        is($!, 'Is a directory', 'Error message is correct');
    }
}

# Test case: File is already open by another process
{
    my ($fh, $filename) = tempfile();
    open(my $handle, '>', $filename) or die "Cannot open file: $!";
    my $result = eval { Path::Class::File::open($filename, 'r') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(!defined $result, 'File is already open, returns undef');
        is($!, 'Text file busy', 'Error message is correct');
    }
    close $handle;
    unlink $filename;
}

# Test case: User does not have permissions to open the file
{
    my $filename = '/root/protected_file';  # Assuming this file is protected
    my $result = eval { Path::Class::File::open($filename, 'r') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(!defined $result, 'User does not have permissions, returns undef');
        like($!, qr/permission denied/i, 'Error message indicates permission issue');
    }
}

done_testing();
