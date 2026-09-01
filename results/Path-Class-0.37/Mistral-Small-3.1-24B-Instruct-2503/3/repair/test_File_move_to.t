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
my $mock;
eval { require File::Copy; };
if ($@) {
    # DEPENDENCY MISSING: File::Copy - mock skipped
} else {
    no strict 'refs';
    if (defined &{"File::Copy::move"}) {
        $mock = mock 'File::Copy', move => sub {
            my ($src, $dest) = @_;
            return 1;  # Simulate successful move
        };
    } else {
        $mock = mock 'File::Copy', add => {
            move => sub {
                my ($src, $dest) = @_;
                return 1;  # Simulate successful move
            }
        };
    }
}

# Test case: Successful move
{
    my ($fh, $filename) = tempfile();
    my $dir = tempdir(CLEANUP => 1);
    my $dest = File::Spec->catfile($dir, 'newfile.txt');

    # Create a mock file object
    my $file = bless { dir => $dir, file => 'originalfile.txt' }, 'Path::Class::File';

    # Mock the stringify method
    mock $file, stringify => sub { return $filename };

    # Mock the new method
    mock 'Path::Class::File', new => sub {
        my ($class, $dest) = @_;
        return bless { dir => $dir, file => 'newfile.txt' }, 'Path::Class::File';
    };

    # Perform the move operation
    my $result = eval { $file->move_to($dest) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(defined $result, 'move_to returns defined result');
        is($result->{dir}, $dir, 'Directory is updated correctly');
        is($result->{file}, 'newfile.txt', 'File name is updated correctly');
    }
}

# Test case: Failed move
{
    my ($fh, $filename) = tempfile();
    my $dir = tempdir(CLEANUP => 1);
    my $dest = File::Spec->catfile($dir, 'newfile.txt');

    # Create a mock file object
    my $file = bless { dir => $dir, file => 'originalfile.txt' }, 'Path::Class::File';

    # Mock the stringify method
    mock $file, stringify => sub { return $filename };

    # Mock the new method
    mock 'Path::Class::File', new => sub {
        my ($class, $dest) = @_;
        return bless { dir => $dir, file => 'newfile.txt' }, 'Path::Class::File';
    };

    # Mock File::Copy::move to fail
    mock 'File::Copy', move => sub {
        return 0;  # Simulate failed move
    };

    # Perform the move operation
    my $result = eval { $file->move_to($dest) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(!defined $result, 'move_to returns undef on failure');
    }
}

# Test case: Edge case - destination path does not exist
{
    my ($fh, $filename) = tempfile();
    my $dir = tempdir(CLEANUP => 1);
    my $dest = File::Spec->catfile($dir, 'nonexistentdir', 'newfile.txt');

    # Create a mock file object
    my $file = bless { dir => $dir, file => 'originalfile.txt' }, 'Path::Class::File';

    # Mock the stringify method
    mock $file, stringify => sub { return $filename };

    # Mock the new method
    mock 'Path::Class::File', new => sub {
        my ($class, $dest) = @_;
        return bless { dir => $dir, file => 'newfile.txt' }, 'Path::Class::File';
    };

    # Perform the move operation
    my $result = eval { $file->move_to($dest) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(!defined $result, 'move_to returns undef when destination path does not exist');
    }
}

done_testing();