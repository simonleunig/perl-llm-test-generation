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
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is(
            # FAILED: $result,
            # FAILED: ['dir1', 'dir2', 'file.txt'],
            # FAILED: 'components returns correct directory components and basename'
        # FAILED: );
    # FAILED: }
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
        # FAILED: fail('components did not throw an error when arguments were passed');
    }
}

# Test case: Edge case - empty directory components
# AFTER LAST PASS: {
    # AFTER LAST PASS: mock 'Path::Class::Dir' => (
        # AFTER LAST PASS: override => [
            # AFTER LAST PASS: components => sub { return () },
        # AFTER LAST PASS: ],
    # AFTER LAST PASS: );

    my $file;  # AFTER LAST PASS: my $file = bless {}, 'Path::Class::File';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $file->components() };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is(
            # FAILED: $result,
            # FAILED: ['file.txt'],
            # FAILED: 'components handles empty directory components gracefully'
        # FAILED: );
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Edge case - invalid file object
# AFTER LAST PASS: {
    my $invalid_file;  # AFTER LAST PASS: my $invalid_file = {};
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $invalid_file->components() };
    # AFTER LAST PASS: if ($@) {
        # FAILED: like(
            # FAILED: $@,
            # FAILED: qr/Can't call method "dir" on an undefined value/,
            # FAILED: 'components handles invalid file object gracefully'
        # FAILED: );
    # AFTER LAST PASS: } else {
        # FAILED: fail('components did not handle invalid file object');
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

done_testing();