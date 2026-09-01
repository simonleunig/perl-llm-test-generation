use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::remove"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'remove is defined'); }

# Mocking rmdir to simulate different scenarios
mock 'CORE::GLOBAL::rmdir' => sub {
    my $dir = shift;
    if ($dir eq 'non_existent_dir') {
        return 0;
    } elsif ($dir eq 'non_empty_dir') {
        return 0;
    } elsif ($dir eq 'permission_denied_dir') {
        return 0;
    } else {
        return 1;
    }
};

# Test case: Successfully remove an empty directory
{
    my $dir = tempdir(CLEANUP => 1);
    my $dir_obj = Path::Class::Dir->new($dir);
    my $result = eval { $dir_obj->remove };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 1, 'Successfully removed an empty directory');
    }
}

# Test case: Attempt to remove a non-existent directory
{
    my $dir_obj = Path::Class::Dir->new('non_existent_dir');
    my $result = eval { $dir_obj->remove };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, undef, 'Failed to remove a non-existent directory');
    }
}

# Test case: Attempt to remove a non-empty directory
{
    my $dir = tempdir(CLEANUP => 1);
    my $file = File::Spec->catfile($dir, 'testfile.txt');
    open(my $fh, '>', $file) or die "Could not create file '$file' $!";
    close($fh);
    my $dir_obj = Path::Class::Dir->new($dir);
    my $result = eval { $dir_obj->remove };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, undef, 'Failed to remove a non-empty directory');
    }
}

# Test case: Attempt to remove a directory with permission issues
{
    my $dir_obj = Path::Class::Dir->new('permission_denied_dir');
    my $result = eval { $dir_obj->remove };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, undef, 'Failed to remove a directory with permission issues');
    }
}

# Test case: Invalid input (not a Path::Class::Dir object)
{
    my $result = eval { Path::Class::Dir->remove('invalid_input') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, undef, 'Failed to remove with invalid input');
    }
}

done_testing();
