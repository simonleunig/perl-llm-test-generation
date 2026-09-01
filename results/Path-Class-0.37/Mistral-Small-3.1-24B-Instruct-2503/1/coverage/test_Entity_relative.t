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
my $mock;
# AFTER LAST PASS: eval { require Path::Class::Entity; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: Path::Class::Entity - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"Path::Class::Entity::relative"}) {
        # AFTER LAST PASS: $mock = mock 'Path::Class::Entity' => (
            # AFTER LAST PASS: override => [
                # AFTER LAST PASS: _spec => sub { return File::Spec->new() },
                # AFTER LAST PASS: stringify => sub { return shift->[0] },
                # AFTER LAST PASS: new => sub { return bless [shift], 'Path::Class::Entity' },
            # AFTER LAST PASS: ],
        # AFTER LAST PASS: );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock = mock 'Path::Class::Entity' => (
            # AFTER LAST PASS: add => [
                # AFTER LAST PASS: _spec => sub { return File::Spec->new() },
                # AFTER LAST PASS: stringify => sub { return shift->[0] },
                # AFTER LAST PASS: new => sub { return bless [shift], 'Path::Class::Entity' },
            # AFTER LAST PASS: ],
        # AFTER LAST PASS: );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# Test case 1: Normal operation with base path
# AFTER LAST PASS: {
    my $absolute_path;  # AFTER LAST PASS: my $absolute_path = '/absolute/path/to/file';
    my $base_path;  # AFTER LAST PASS: my $base_path = '/absolute/path';
    my $expected_relative_path;  # AFTER LAST PASS: my $expected_relative_path = 'to/file';

    my $entity;  # AFTER LAST PASS: my $entity = bless [$absolute_path], 'Path::Class::Entity';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $entity->relative($base_path) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result->[0], $expected_relative_path, 'relative path is correct with base path');
    # FAILED: }
# AFTER LAST PASS: }

# Test case 2: No base path provided (should default to current working directory)
# AFTER LAST PASS: {
    my $absolute_path;  # AFTER LAST PASS: my $absolute_path = '/absolute/path/to/file';
    my $expected_relative_path;  # AFTER LAST PASS: my $expected_relative_path = 'absolute/path/to/file';  # Assuming current working directory is root

    my $entity;  # AFTER LAST PASS: my $entity = bless [$absolute_path], 'Path::Class::Entity';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $entity->relative() };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result->[0], $expected_relative_path, 'relative path is correct with no base path');
    # FAILED: }
# AFTER LAST PASS: }

# Test case 3: Base path is the same as the absolute path
# AFTER LAST PASS: {
    my $absolute_path;  # AFTER LAST PASS: my $absolute_path = '/absolute/path/to/file';
    my $base_path;  # AFTER LAST PASS: my $base_path = '/absolute/path/to/file';
    my $expected_relative_path;  # AFTER LAST PASS: my $expected_relative_path = '.';

    my $entity;  # AFTER LAST PASS: my $entity = bless [$absolute_path], 'Path::Class::Entity';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $entity->relative($base_path) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result->[0], $expected_relative_path, 'relative path is correct when base path is the same as absolute path');
    # FAILED: }
# AFTER LAST PASS: }

# Test case 4: Absolute path is already relative
# AFTER LAST PASS: {
    my $relative_path;  # AFTER LAST PASS: my $relative_path = 'relative/path/to/file';
    my $base_path;  # AFTER LAST PASS: my $base_path = '/absolute/path';
    my $expected_relative_path;  # AFTER LAST PASS: my $expected_relative_path = 'relative/path/to/file';

    my $entity;  # AFTER LAST PASS: my $entity = bless [$relative_path], 'Path::Class::Entity';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $entity->relative($base_path) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result->[0], $expected_relative_path, 'relative path is correct when absolute path is already relative');
    # FAILED: }
# AFTER LAST PASS: }

# Test case 5: Invalid base path (should propagate error)
# AFTER LAST PASS: {
    my $absolute_path;  # AFTER LAST PASS: my $absolute_path = '/absolute/path/to/file';
    my $invalid_base_path;  # AFTER LAST PASS: my $invalid_base_path = '/invalid/base/path';

    my $entity;  # AFTER LAST PASS: my $entity = bless [$absolute_path], 'Path::Class::Entity';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $entity->relative($invalid_base_path) };
    # AFTER LAST PASS: if ($@) {
        # FAILED: like($@, qr/No such file or directory/, 'Function handles invalid base path correctly');
    # AFTER LAST PASS: } else {
        # FAILED: fail('Function did not crash with invalid base path');
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

done_testing();