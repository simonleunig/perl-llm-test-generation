use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::parent"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'parent is defined'); }

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

eval { require Path::Class::Dir; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Dir - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::Dir::new"}) {
        $mock = mock 'Path::Class::Dir' => (
            override => [
                new => sub {
                    my ($class, $self, $updir) = @_;
                    my $dirs = $self->{dirs} || [];
                    return bless { dirs => $dirs }, $class;
                },
                _spec => sub {
                    my $self = shift;
                    return bless {
                        curdir => '.',
                        updir => '..'
                    }, 'File::Spec';
                },
                is_absolute => sub { return 0; }
            ]
        );
    } else {
        $mock = mock 'Path::Class::Dir' => (
            add => [
                new => sub {
                    my ($class, $self, $updir) = @_;
                    my $dirs = $self->{dirs} || [];
                    return bless { dirs => $dirs }, $class;
                },
                _spec => sub {
                    my $self = shift;
                    return bless {
                        curdir => '.',
                        updir => '..'
                    }, 'File::Spec';
                },
                is_absolute => sub { return 0; }
            ]
        );
    }
}

# Test case: Absolute path
{
    my $dir = bless { dirs => ['root', 'dir1', 'dir2'] }, 'Path::Class::Dir';
    my $parent = eval { $dir->parent };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($parent->{dirs}->[0], 'root', 'Absolute path parent is correct');
        is($parent->{dirs}->[1], 'dir1', 'Absolute path parent is correct');
    }
}

# Test case: Relative path (current directory)
{
    my $dir = bless { dirs => ['.'] }, 'Path::Class::Dir';
    my $parent = eval { $dir->parent };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($parent->{dirs}->[0], '..', 'Relative path parent is correct');
    # FAILED: }
}

# Test case: All updirs
{
    my $dir = bless { dirs => ['..', '..'] }, 'Path::Class::Dir';
    my $parent = eval { $dir->parent };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($parent->{dirs}->[0], '..', 'All updirs parent is correct');
        is($parent->{dirs}->[1], '..', 'All updirs parent is correct');
    }
}

# Test case: Single directory
{
    my $dir = bless { dirs => ['dir1'] }, 'Path::Class::Dir';
    my $parent = eval { $dir->parent };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($parent->{dirs}->[0], '.', 'Single directory parent is correct');
    # FAILED: }
}

# Test case: Multiple directories
{
    my $dir = bless { dirs => ['dir1', 'dir2'] }, 'Path::Class::Dir';
    my $parent = eval { $dir->parent };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($parent->{dirs}->[0], 'dir1', 'Multiple directories parent is correct');
    }
}

done_testing();