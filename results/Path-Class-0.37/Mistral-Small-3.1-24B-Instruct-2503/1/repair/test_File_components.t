use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw(tempfile tempdir);
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::components"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'components is defined'); }

# Mocking dependencies
my $mock_dir;
eval { require Path::Class::Dir; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Dir - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::Dir::components"}) {
        $mock_dir = mock 'Path::Class::Dir' => ( override => [
            components => sub { return ('dir1', 'dir2') },
        ]);
    } else {
        $mock_dir = mock 'Path::Class::Dir' => ( add => [
            components => sub { return ('dir1', 'dir2') },
        ]);
    }
}

my $mock_entity;
eval { require Path::Class::Entity; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Entity - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::Entity::dir"}) {
        $mock_entity = mock 'Path::Class::Entity' => ( override => [
            dir => sub { return bless {}, 'Path::Class::Dir' },
            basename => sub { return 'file.txt' },
        ]);
    } else {
        $mock_entity = mock 'Path::Class::Entity' => ( add => [
            dir => sub { return bless {}, 'Path::Class::Dir' },
            basename => sub { return 'file.txt' },
        ]);
    }
}

# Test case: Normal operation
{
    my $file = bless {}, 'Path::Class::File';
    my $result = eval { $file->components() };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is(
            $result,
            ['dir1', 'dir2', 'file.txt'],
            'components returns correct directory components and basename'
        );
    }
}

# Test case: Passing arguments should throw an error
{
    my $file = bless {}, 'Path::Class::File';
    my $result = eval { $file->components('extra_arg') };
    if ($@) {
        like(
            $@,
            qr/Arguments are not currently supported by File->components\(\)/,
            'components throws an error when arguments are passed'
        );
    } else {
        fail('components did not throw an error when arguments were passed');
    }
}

# Test case: Edge case - empty directory components
{
    mock 'Path::Class::Dir' => (
        override => [
            components => sub { return () },
        ],
    );

    my $file = bless {}, 'Path::Class::File';
    my $result = eval { $file->components() };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is(
            $result,
            ['file.txt'],
            'components handles empty directory components gracefully'
        );
    }
}

# Test case: Edge case - invalid file object
{
    my $invalid_file = {};
    my $result = eval { $invalid_file->components() };
    if ($@) {
        like(
            $@,
            qr/Can't call method "dir" on an undefined value/,
            'components handles invalid file object gracefully'
        );
    } else {
        fail('components did not handle invalid file object');
    }
}

done_testing();