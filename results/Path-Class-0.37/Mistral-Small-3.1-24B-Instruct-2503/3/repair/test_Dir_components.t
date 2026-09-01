use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::components"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'components is defined'); }

# Mocking dependencies
my $mock;
eval { require Path::Class::Entity; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Entity - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::Entity::dir_list"}) {
        $mock = mock 'Path::Class::Entity' => (
            override => [
                dir_list => sub {
                    my $self = shift;
                    return @_;
                },
            ],
        );
    } else {
        $mock = mock 'Path::Class::Entity' => (
            add => [
                dir_list => sub {
                    my $self = shift;
                    return @_;
                },
            ],
        );
    }
}

# Test case: Empty directory list
{
    my $dir = bless {}, 'Path::Class::Dir';
    my $result = eval { $dir->components() };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, [], 'components returns empty list for empty directory list');
    }
}

# Test case: No arguments provided
{
    my $dir = bless { dir_list => ['dir1', 'dir2', 'dir3'] }, 'Path::Class::Dir';
    my $result = eval { $dir->components() };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, ['dir1', 'dir2', 'dir3'], 'components returns full directory list when no arguments are provided');
    }
}

# Test case: Single argument (OFFSET)
{
    my $dir = bless { dir_list => ['dir1', 'dir2', 'dir3'] }, 'Path::Class::Dir';
    my $result = eval { $dir->components(1) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 'dir2', 'components returns element at specified offset');
    }
}

# Test case: Two arguments (OFFSET and LENGTH)
{
    my $dir = bless { dir_list => ['dir1', 'dir2', 'dir3'] }, 'Path::Class::Dir';
    my $result = eval { $dir->components(1, 2) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, ['dir2', 'dir3'], 'components returns specified slice of the directory list');
    }
}

# Test case: Negative OFFSET
{
    my $dir = bless { dir_list => ['dir1', 'dir2', 'dir3'] }, 'Path::Class::Dir';
    my $result = eval { $dir->components(-1) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 'dir3', 'components handles negative offset correctly');
    }
}

# Test case: Negative LENGTH
{
    my $dir = bless { dir_list => ['dir1', 'dir2', 'dir3'] }, 'Path::Class::Dir';
    my $result = eval { $dir->components(1, -1) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, [], 'components handles negative length correctly');
    }
}

# Test case: OFFSET out of range
{
    my $dir = bless { dir_list => ['dir1', 'dir2', 'dir3'] }, 'Path::Class::Dir';
    my $result = eval { $dir->components(5) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, undef, 'components returns undef for out-of-range offset');
    }
}

# Test case: LENGTH out of range
{
    my $dir = bless { dir_list => ['dir1', 'dir2', 'dir3'] }, 'Path::Class::Dir';
    my $result = eval { $dir->components(1, 5) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, ['dir2', 'dir3'], 'components returns available elements for out-of-range length');
    }
}

done_testing();