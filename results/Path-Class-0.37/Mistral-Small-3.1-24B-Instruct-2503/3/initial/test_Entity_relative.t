use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Entity; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Entity::relative"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'relative is defined'); }

# Mocking dependencies
mock 'Path::Class::Entity' => (
    override => [
        _spec => sub { return File::Spec->new() },
        stringify => sub { return shift->[0] },
        new => sub { return bless [shift], 'Path::Class::Entity' },
    ],
);

# Test case 1: Normal operation with base path
{
    my $absolute_path = '/absolute/path/to/file';
    my $base_path = '/absolute/path';
    my $expected_relative_path = 'to/file';

    my $entity = bless [$absolute_path], 'Path::Class::Entity';
    my $result = eval { $entity->relative($base_path) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result->[0], $expected_relative_path, 'relative path is correct with base path');
    }
}

# Test case 2: No base path provided (should default to current working directory)
{
    my $absolute_path = '/absolute/path/to/file';
    my $expected_relative_path = 'absolute/path/to/file';  # Assuming current working directory is root

    my $entity = bless [$absolute_path], 'Path::Class::Entity';
    my $result = eval { $entity->relative() };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result->[0], $expected_relative_path, 'relative path is correct with no base path');
    }
}

# Test case 3: Base path is the same as the absolute path
{
    my $absolute_path = '/absolute/path/to/file';
    my $base_path = '/absolute/path/to/file';
    my $expected_relative_path = '.';

    my $entity = bless [$absolute_path], 'Path::Class::Entity';
    my $result = eval { $entity->relative($base_path) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result->[0], $expected_relative_path, 'relative path is correct when base path is the same as absolute path');
    }
}

# Test case 4: Absolute path is already relative
{
    my $relative_path = 'relative/path/to/file';
    my $base_path = '/absolute/path';
    my $expected_relative_path = 'relative/path/to/file';

    my $entity = bless [$relative_path], 'Path::Class::Entity';
    my $result = eval { $entity->relative($base_path) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result->[0], $expected_relative_path, 'relative path is correct when absolute path is already relative');
    }
}

# Test case 5: Invalid base path (should propagate error)
{
    my $absolute_path = '/absolute/path/to/file';
    my $invalid_base_path = '/invalid/base/path';

    my $entity = bless [$absolute_path], 'Path::Class::Entity';
    my $result = eval { $entity->relative($invalid_base_path) };
    if ($@) {
        like($@, qr/No such file or directory/, 'Function handles invalid base path correctly');
    } else {
        fail('Function did not crash with invalid base path');
    }
}

done_testing();
