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

# Mocking rmdir to avoid actual file system operations
mock 'CORE::GLOBAL::rmdir' => sub {
    my ($dir) = @_;
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

# Test case: Successful directory removal
{
    my $dir = Path::Class::Dir->new('test_dir');
    my $result = eval { $dir->remove() };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 1, 'Directory removed successfully');
    }
}

# Test case: Non-existent directory
{
    my $dir = Path::Class::Dir->new('non_existent_dir');
    my $result = eval { $dir->remove() };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, undef, 'Non-existent directory removal returns undef');
    }
}

# Test case: Non-empty directory
{
    my $dir = Path::Class::Dir->new('non_empty_dir');
    my $result = eval { $dir->remove() };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, undef, 'Non-empty directory removal returns undef');
    }
}

# Test case: Permission denied
{
    my $dir = Path::Class::Dir->new('permission_denied_dir');
    my $result = eval { $dir->remove() };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, undef, 'Permission denied directory removal returns undef');
    }
}

# Test case: Invalid input (not a Path::Class::Dir object)
{
    my $result = eval { Path::Class::Dir::remove('invalid_input') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, undef, 'Invalid input returns undef');
    }
}

done_testing();
