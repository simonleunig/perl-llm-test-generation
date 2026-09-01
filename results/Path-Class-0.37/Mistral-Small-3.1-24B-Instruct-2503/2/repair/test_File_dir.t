use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::dir"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'dir is defined'); }

# Mock dependencies
my $mock_dir;
eval { require Path::Class::Dir; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Dir - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::Dir::new"}) {
        $mock_dir = mock 'Path::Class::Dir' => (
            override => [
                new => sub {
                    my ($class, $path) = @_;
                    return bless { path => $path }, $class;
                }
            ]
        );
    } else {
        $mock_dir = mock 'Path::Class::Dir' => (
            add => [
                new => sub {
                    my ($class, $path) = @_;
                    return bless { path => $path }, $class;
                }
            ]
        );
    }
}

my $mock_file;
eval { require Path::Class::File; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::File - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::File::dir_class"}) {
        $mock_file = mock 'Path::Class::File' => (
            override => [
                dir_class => sub { 'Path::Class::Dir' },
                _spec => sub {
                    my $self = shift;
                    return bless { curdir => 'current_dir' }, 'Path::Class::File::Spec';
                }
            ]
        );
    } else {
        $mock_file = mock 'Path::Class::File' => (
            add => [
                dir_class => sub { 'Path::Class::Dir' },
                _spec => sub {
                    my $self = shift;
                    return bless { curdir => 'current_dir' }, 'Path::Class::File::Spec';
                }
            ]
        );
    }
}

# Test case: Directory is already defined
{
    my $file = bless { dir => 'existing_dir' }, 'Path::Class::File';
    my $result = eval { $file->dir };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result->{path}, 'existing_dir', 'Returns existing directory when defined');
    }
}

# Test case: Directory is not defined
{
    my $file = bless {}, 'Path::Class::File';
    my $result = eval { $file->dir };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result->{path}, 'current_dir', 'Returns new directory object when not defined');
    }
}

# Test case: Edge case with relative path
{
    mock 'Path::Class::File' => (
        override => [
            _spec => sub {
                my $self = shift;
                return bless { curdir => 'relative_path' }, 'Path::Class::File::Spec';
            }
        ]
    );

    my $file = bless {}, 'Path::Class::File';
    my $result = eval { $file->dir };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result->{path}, 'relative_path', 'Handles relative path correctly');
    }
}

# Test case: Edge case with absolute path
{
    mock 'Path::Class::File' => (
        override => [
            _spec => sub {
                my $self = shift;
                return bless { curdir => '/absolute_path' }, 'Path::Class::File::Spec';
            }
        ]
    );

    my $file = bless {}, 'Path::Class::File';
    my $result = eval { $file->dir };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result->{path}, '/absolute_path', 'Handles absolute path correctly');
    }
}

# Test case: Error handling in dir_class
{
    mock 'Path::Class::File' => (
        override => [
            dir_class => sub { die 'dir_class error' }
        ]
    );

    my $file = bless {}, 'Path::Class::File';
    my $result = eval { $file->dir };
    if (!$@) { fail('Function did not crash as expected'); } else {
        like($@, qr/dir_class error/, 'Propagates error from dir_class');
    }
}

# Test case: Error handling in _spec->curdir
{
    mock 'Path::Class::File' => (
        override => [
            _spec => sub {
                my $self = shift;
                return bless { curdir => sub { die 'curdir error' } }, 'Path::Class::File::Spec';
            }
        ]
    );

    my $file = bless {}, 'Path::Class::File';
    my $result = eval { $file->dir };
    if (!$@) { fail('Function did not crash as expected'); } else {
        like($@, qr/curdir error/, 'Propagates error from _spec->curdir');
    }
}

done_testing();