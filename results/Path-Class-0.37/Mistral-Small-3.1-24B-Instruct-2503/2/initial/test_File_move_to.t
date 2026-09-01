use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::move_to"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'move_to is defined'); }

# Mocking File::Copy::move
mock 'File::Copy', move => sub {
    my ($src, $dest) = @_;
    return 1;  # Simulate successful move
};

# Test case: Successful move
{
    my ($fh, $filename) = tempfile();
    my $dest_dir = tempdir(CLEANUP => 1);
    my $dest_file = File::Spec->catfile($dest_dir, 'newfile.txt');

    my $file = Path::Class::File->new($filename);
    my $result = eval { $file->move_to($dest_file) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(defined $result, 'move_to returns defined result');
        is($result->stringify, $dest_file, 'File path updated correctly');
    }

    # Clean up
    unlink $filename;
}

# Mocking File::Copy::move to simulate failure
mock 'File::Copy', move => sub {
    my ($src, $dest) = @_;
    return 0;  # Simulate failed move
};

# Test case: Failed move
{
    my ($fh, $filename) = tempfile();
    my $dest_dir = tempdir(CLEANUP => 1);
    my $dest_file = File::Spec->catfile($dest_dir, 'newfile.txt');

    my $file = Path::Class::File->new($filename);
    my $result = eval { $file->move_to($dest_file) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(!defined $result, 'move_to returns undef on failure');
    }

    # Clean up
    unlink $filename;
}

# Test case: Destination path does not exist
{
    my ($fh, $filename) = tempfile();
    my $dest_file = '/nonexistent/path/newfile.txt';

    my $file = Path::Class::File->new($filename);
    my $result = eval { $file->move_to($dest_file) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(!defined $result, 'move_to returns undef when destination path does not exist');
    }

    # Clean up
    unlink $filename;
}

# Test case: File to be moved does not exist
{
    my $filename = '/nonexistent/file.txt';
    my $dest_dir = tempdir(CLEANUP => 1);
    my $dest_file = File::Spec->catfile($dest_dir, 'newfile.txt');

    my $file = Path::Class::File->new($filename);
    my $result = eval { $file->move_to($dest_file) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(!defined $result, 'move_to returns undef when file to be moved does not exist');
    }
}

done_testing();
