use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::dir_list"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'dir_list is defined'); }

# Mocking dependencies
mock 'Path::Class::File' => ( new => sub { return bless {}, 'Path::Class::File' } );
mock 'Path::Class::Entity' => ( new => sub { return bless {}, 'Path::Class::Entity' } );
mock 'IO::Dir' => ( new => sub { return bless {}, 'IO::Dir' } );
mock 'File::Path' => ( rmdir => sub { return 1 } );
mock 'File::Temp' => ( tempdir => sub { return 'tempdir' } );
mock 'Scalar::Util' => ( blessed => sub { return 1 } );

# Test cases with eval protection

# Test case 1: No arguments provided, should return the entire list
{
    my $dir = bless { dirs => ['dir1', 'dir2', 'dir3'] }, 'Path::Class::Dir';
    my $result = eval { $dir->dir_list() };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, ['dir1', 'dir2', 'dir3'], 'dir_list returns entire list when no arguments are provided');
    }
}

# Test case 2: Positive offset, should return elements from the offset
{
    my $dir = bless { dirs => ['dir1', 'dir2', 'dir3'] }, 'Path::Class::Dir';
    my $result = eval { $dir->dir_list(1) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, ['dir2', 'dir3'], 'dir_list returns elements from the positive offset');
    }
}

# Test case 3: Negative offset, should return elements from the end
{
    my $dir = bless { dirs => ['dir1', 'dir2', 'dir3'] }, 'Path::Class::Dir';
    my $result = eval { $dir->dir_list(-1) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, ['dir3'], 'dir_list returns elements from the negative offset');
    }
}

# Test case 4: Positive offset and length, should return specified number of elements
{
    my $dir = bless { dirs => ['dir1', 'dir2', 'dir3'] }, 'Path::Class::Dir';
    my $result = eval { $dir->dir_list(1, 1) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, ['dir2'], 'dir_list returns specified number of elements from the positive offset');
    }
}

# Test case 5: Negative length, should exclude specified number of elements from the end
{
    my $dir = bless { dirs => ['dir1', 'dir2', 'dir3'] }, 'Path::Class::Dir';
    my $result = eval { $dir->dir_list(0, -1) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, ['dir1', 'dir2'], 'dir_list excludes specified number of elements from the end');
    }
}

# Test case 6: Scalar context, should return the single element at the specified offset
{
    my $dir = bless { dirs => ['dir1', 'dir2', 'dir3'] }, 'Path::Class::Dir';
    my $result = eval { scalar $dir->dir_list(1) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 'dir2', 'dir_list returns the single element at the specified offset in scalar context');
    }
}

# Test case 7: Scalar context with no arguments, should return the number of elements
{
    my $dir = bless { dirs => ['dir1', 'dir2', 'dir3'] }, 'Path::Class::Dir';
    my $result = eval { scalar $dir->dir_list() };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 3, 'dir_list returns the number of elements in scalar context with no arguments');
    }
}

done_testing();
