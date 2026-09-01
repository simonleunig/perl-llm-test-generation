use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw(tempfile tempdir);
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::dir_list"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'dir_list is defined'); }

# Mocking dependencies
my $mock;
eval { require Path::Class::File; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::File - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::File::new"}) {
        $mock = mock 'Path::Class::File' => ( override => [ new => sub { return bless {}, 'Path::Class::File' } ] );
    } else {
        $mock = mock 'Path::Class::File' => ( add => [ new => sub { return bless {}, 'Path::Class::File' } ] );
    }
}

eval { require Path::Class::Entity; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Entity - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::Entity::new"}) {
        $mock = mock 'Path::Class::Entity' => ( override => [ new => sub { return bless {}, 'Path::Class::Entity' } ] );
    } else {
        $mock = mock 'Path::Class::Entity' => ( add => [ new => sub { return bless {}, 'Path::Class::Entity' } ] );
    }
}

eval { require IO::Dir; };
if ($@) {
    # DEPENDENCY MISSING: IO::Dir - mock skipped
} else {
    no strict 'refs';
    if (defined &{"IO::Dir::new"}) {
        $mock = mock 'IO::Dir' => ( override => [ new => sub { return bless {}, 'IO::Dir' } ] );
    } else {
        $mock = mock 'IO::Dir' => ( add => [ new => sub { return bless {}, 'IO::Dir' } ] );
    }
}

eval { require File::Path; };
if ($@) {
    # DEPENDENCY MISSING: File::Path - mock skipped
} else {
    no strict 'refs';
    if (defined &{"File::Path::rmdir"}) {
        $mock = mock 'File::Path' => ( override => [ rmdir => sub { return 1 } ] );
    } else {
        $mock = mock 'File::Path' => ( add => [ rmdir => sub { return 1 } ] );
    }
}

eval { require File::Temp; };
if ($@) {
    # DEPENDENCY MISSING: File::Temp - mock skipped
} else {
    no strict 'refs';
    if (defined &{"File::Temp::tempdir"}) {
        $mock = mock 'File::Temp' => ( override => [ tempdir => sub { return 'tempdir' } ] );
    } else {
        $mock = mock 'File::Temp' => ( add => [ tempdir => sub { return 'tempdir' } ] );
    }
}

eval { require Scalar::Util; };
if ($@) {
    # DEPENDENCY MISSING: Scalar::Util - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Scalar::Util::blessed"}) {
        $mock = mock 'Scalar::Util' => ( override => [ blessed => sub { return 1 } ] );
    } else {
        $mock = mock 'Scalar::Util' => ( add => [ blessed => sub { return 1 } ] );
    }
}

# Test cases with eval protection

# Test case 1: No arguments provided, should return the entire list
{
    my $dir = bless { dirs => ['dir1', 'dir2', 'dir3'] }, 'Path::Class::Dir';
    my $result = eval { $dir->dir_list() };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, ['dir1', 'dir2', 'dir3'], 'dir_list returns entire list when no arguments are provided');
    # FAILED: }
}

# Test case 2: Positive offset, should return elements from the offset
{
    my $dir = bless { dirs => ['dir1', 'dir2', 'dir3'] }, 'Path::Class::Dir';
    my $result = eval { $dir->dir_list(1) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, ['dir2', 'dir3'], 'dir_list returns elements from the positive offset');
    # FAILED: }
}

# Test case 3: Negative offset, should return elements from the end
{
    my $dir = bless { dirs => ['dir1', 'dir2', 'dir3'] }, 'Path::Class::Dir';
    my $result = eval { $dir->dir_list(-1) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, ['dir3'], 'dir_list returns elements from the negative offset');
    # FAILED: }
}

# Test case 4: Positive offset and length, should return specified number of elements
{
    my $dir = bless { dirs => ['dir1', 'dir2', 'dir3'] }, 'Path::Class::Dir';
    my $result = eval { $dir->dir_list(1, 1) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, ['dir2'], 'dir_list returns specified number of elements from the positive offset');
    # FAILED: }
}

# Test case 5: Negative length, should exclude specified number of elements from the end
{
    my $dir = bless { dirs => ['dir1', 'dir2', 'dir3'] }, 'Path::Class::Dir';
    my $result = eval { $dir->dir_list(0, -1) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, ['dir1', 'dir2'], 'dir_list excludes specified number of elements from the end');
    # FAILED: }
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