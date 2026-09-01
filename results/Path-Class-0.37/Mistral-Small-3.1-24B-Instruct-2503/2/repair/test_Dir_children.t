use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::children"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'children is defined'); }

# Mock dependencies
my $mock_io_dir;
eval { require IO::Dir; };
if ($@) {
    # DEPENDENCY MISSING: IO::Dir - mock skipped
} else {
    no strict 'refs';
    if (defined &{"IO::Dir::new"}) {
        $mock_io_dir = mock 'IO::Dir' => (
            override => [
                new => sub { bless {}, 'IO::Dir' },
                read => sub { shift; return shift @{ $_[0] } },
            ],
        );
    } else {
        $mock_io_dir = mock 'IO::Dir' => (
            add => [
                new => sub { bless {}, 'IO::Dir' },
                read => sub { shift; return shift @{ $_[0] } },
            ],
        );
    }
}

my $mock_path_class_dir;
eval { require Path::Class::Dir; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Dir - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::Dir::open"}) {
        $mock_path_class_dir = mock 'Path::Class::Dir' => (
            override => [
                open => sub { return bless {}, 'IO::Dir' },
                _is_local_dot_dir => sub { return shift->[0] eq '.' || shift->[0] eq '..' },
                file => sub { return bless { name => shift }, 'Path::Class::File' },
                subdir => sub { return bless { name => shift }, 'Path::Class::Dir' },
            ],
        );
    } else {
        $mock_path_class_dir = mock 'Path::Class::Dir' => (
            add => [
                open => sub { return bless {}, 'IO::Dir' },
                _is_local_dot_dir => sub { return shift->[0] eq '.' || shift->[0] eq '..' },
                file => sub { return bless { name => shift }, 'Path::Class::File' },
                subdir => sub { return bless { name => shift }, 'Path::Class::Dir' },
            ],
        );
    }
}

# Test case: Normal operation with no options
{
    my $dir = bless {}, 'Path::Class::Dir';
    my @entries = ('file1', 'dir1', 'file2');
    mock 'IO::Dir' => ( override => [ read => sub { return shift @entries } ] );

    my $result = eval { $dir->children };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is( scalar @$result, 3, 'Correct number of entries returned' );
        is( $result->[0]->{name}, 'file1', 'First entry is correct' );
        is( $result->[1]->{name}, 'dir1', 'Second entry is correct' );
        is( $result->[2]->{name}, 'file2', 'Third entry is correct' );
    }
}

# Test case: Including special directory entries with 'all' option
{
    my $dir = bless {}, 'Path::Class::Dir';
    my @entries = ('.', '..', 'file1', 'dir1');
    mock 'IO::Dir' => ( override => [ read => sub { return shift @entries } ] );

    my $result = eval { $dir->children(all => 1) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is( scalar @$result, 4, 'Correct number of entries returned with all option' );
        is( $result->[0]->{name}, '.', 'First entry is correct' );
        is( $result->[1]->{name}, '..', 'Second entry is correct' );
        is( $result->[2]->{name}, 'file1', 'Third entry is correct' );
        is( $result->[3]->{name}, 'dir1', 'Fourth entry is correct' );
    }
}

# Test case: Excluding hidden files with 'no_hidden' option
{
    my $dir = bless {}, 'Path::Class::Dir';
    my @entries = ('.hidden', 'file1', 'dir1', '.another_hidden');
    mock 'IO::Dir' => ( override => [ read => sub { return shift @entries } ] );

    my $result = eval { $dir->children(no_hidden => 1) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is( scalar @$result, 2, 'Correct number of entries returned with no_hidden option' );
        is( $result->[0]->{name}, 'file1', 'First entry is correct' );
        is( $result->[1]->{name}, 'dir1', 'Second entry is correct' );
    }
}

# Test case: Directory cannot be opened
{
    my $dir = bless {}, 'Path::Class::Dir';
    mock 'Path::Class::Dir' => ( override => [ open => sub { return undef } ] );

    my $result = eval { $dir->children };
    if ($@) {
        like( $@, qr/Can't open directory/, 'Correct error message for directory open failure' );
    } else {
        fail('Function did not crash as expected');
    }
}

# Test case: Directory with mixed file types
{
    my $dir = bless {}, 'Path::Class::Dir';
    my @entries = ('file1', 'dir1', 'file2');
    mock 'IO::Dir' => ( override => [ read => sub { return shift @entries } ] );

    my $result = eval { $dir->children };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is( scalar @$result, 3, 'Correct number of entries returned' );
        is( $result->[0]->{name}, 'file1', 'First entry is correct' );
        isa_ok( $result->[0], 'Path::Class::File', 'First entry is a Path::Class::File' );
        is( $result->[1]->{name}, 'dir1', 'Second entry is correct' );
        isa_ok( $result->[1], 'Path::Class::Dir', 'Second entry is a Path::Class::Dir' );
        is( $result->[2]->{name}, 'file2', 'Third entry is correct' );
        isa_ok( $result->[2], 'Path::Class::File', 'Third entry is a Path::Class::File' );
    }
}

done_testing();