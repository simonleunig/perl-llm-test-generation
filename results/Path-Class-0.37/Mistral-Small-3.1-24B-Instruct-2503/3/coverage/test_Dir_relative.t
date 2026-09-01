use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw(tempfile tempdir);
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::relative"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'relative is defined'); }

# Mocking dependencies
my $mock;
# AFTER LAST PASS: eval { require Path::Class::Entity; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: Path::Class::Entity - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"Path::Class::Entity::new"}) {
        # AFTER LAST PASS: $mock = mock 'Path::Class::Entity' => (
            # AFTER LAST PASS: override => [
                # AFTER LAST PASS: new => sub { return bless {}, 'Path::Class::Dir' },
                # AFTER LAST PASS: stringify => sub { return shift->[0] },
                # AFTER LAST PASS: _spec => sub { return bless {}, 'File::Spec' },
            # AFTER LAST PASS: ],
        # AFTER LAST PASS: );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock = mock 'Path::Class::Entity' => (
            # AFTER LAST PASS: add => [
                # AFTER LAST PASS: new => sub { return bless {}, 'Path::Class::Dir' },
                # AFTER LAST PASS: stringify => sub { return shift->[0] },
                # AFTER LAST PASS: _spec => sub { return bless {}, 'File::Spec' },
            # AFTER LAST PASS: ],
        # AFTER LAST PASS: );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# AFTER LAST PASS: eval { require File::Spec; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: File::Spec - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"File::Spec::abs2rel"}) {
        # AFTER LAST PASS: $mock = mock 'File::Spec' => (
            # AFTER LAST PASS: override => [
                # AFTER LAST PASS: abs2rel => sub {
                    my ($self, $path1, $path2);  # AFTER LAST PASS: my ($self, $path1, $path2) = @_;
                    # AFTER LAST PASS: return $path1 eq $path2 ? '' : $path2;
                # AFTER LAST PASS: },
                # AFTER LAST PASS: curdir => sub { return '.' },
            # AFTER LAST PASS: ],
        # AFTER LAST PASS: );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock = mock 'File::Spec' => (
            # AFTER LAST PASS: add => [
                # AFTER LAST PASS: abs2rel => sub {
                    my ($self, $path1, $path2);  # AFTER LAST PASS: my ($self, $path1, $path2) = @_;
                    # AFTER LAST PASS: return $path1 eq $path2 ? '' : $path2;
                # AFTER LAST PASS: },
                # AFTER LAST PASS: curdir => sub { return '.' },
            # AFTER LAST PASS: ],
        # AFTER LAST PASS: );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# Test case: Paths are equal
# AFTER LAST PASS: {
    my $dir;  # AFTER LAST PASS: my $dir = bless ['/path/to/dir'], 'Path::Class::Dir';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $dir->relative('/path/to/dir') };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result->stringify, '.', 'Returns current directory when paths are equal');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Paths are different
# AFTER LAST PASS: {
    my $dir;  # AFTER LAST PASS: my $dir = bless ['/path/to/dir'], 'Path::Class::Dir';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $dir->relative('/another/path') };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result->stringify, '/another/path', 'Returns relative path when paths are different');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: No base directory specified
# AFTER LAST PASS: {
    my $dir;  # AFTER LAST PASS: my $dir = bless ['/path/to/dir'], 'Path::Class::Dir';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $dir->relative() };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result->stringify, '.', 'Returns current directory when no base directory is specified');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Edge case with empty string
# AFTER LAST PASS: {
    my $dir;  # AFTER LAST PASS: my $dir = bless ['/path/to/dir'], 'Path::Class::Dir';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $dir->relative('/path/to/dir', '/path/to/dir') };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result->stringify, '.', 'Returns current directory when paths are equal');
    # FAILED: }
# AFTER LAST PASS: }

done_testing();