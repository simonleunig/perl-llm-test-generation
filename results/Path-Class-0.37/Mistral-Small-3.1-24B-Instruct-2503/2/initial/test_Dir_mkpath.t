use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::mkpath"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'mkpath is defined'); }

# Mock File::Path::mkpath
mock 'File::Path::mkpath' => sub {
    my ($path, %opts) = @_;
    return $path;
};

# Test case: Successful directory creation
{
    my $dir = Path::Class::Dir->new('test_dir');
    my $result = eval { Path::Class::Dir::mkpath($dir) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 'test_dir', 'Directory created successfully');
    }
}

# Test case: Directory already exists
{
    my $dir = Path::Class::Dir->new('existing_dir');
    my $tempdir = tempdir(CLEANUP => 1);
    my $full_path = File::Spec->catfile($tempdir, 'existing_dir');
    mkdir $full_path;
    my $result = eval { Path::Class::Dir::mkpath($dir) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 'existing_dir', 'Directory already exists');
    }
}

# Test case: Invalid directory path
{
    my $dir = Path::Class::Dir->new('invalid:dir');
    my $result = eval { Path::Class::Dir::mkpath($dir) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, undef, 'Invalid directory path');
    }
}

# Test case: Directory creation with additional options
{
    my $dir = Path::Class::Dir->new('test_dir_with_options');
    my $result = eval { Path::Class::Dir::mkpath($dir, 0, 0755) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 'test_dir_with_options', 'Directory created with additional options');
    }
}

# Test case: Directory creation fails due to permission issues
{
    my $dir = Path::Class::Dir->new('/non_existent_path/test_dir');
    mock 'File::Path::mkpath' => sub {
        die 'Permission denied';
    };
    my $result = eval { Path::Class::Dir::mkpath($dir) };
    if ($@) {
        like($@, qr/Permission denied/, 'Directory creation fails with permission error');
    } else {
        fail('Function did not crash as expected');
    }
}

done_testing();
