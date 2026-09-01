use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Entity; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Entity::cleanup"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'cleanup is defined'); }

# Mocking dependencies
mock 'Path::Class::Entity' => (
    override => [
        new => sub { my $class = shift; return bless { path => shift }, $class; },
        _spec => sub { return File::Spec->can('canonpath'); },
    ],
);

# Test cases with eval protection

# Normal case: Path with redundant components
my $path_with_redundant = Path::Class::Entity->new('a/b/../c/./d');
my $result = eval { $path_with_redundant->cleanup() };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result->stringify(), 'a/c/d', 'cleanup normalizes path with redundant components');
}

# Edge case: Empty path
my $empty_path = Path::Class::Entity->new('');
$result = eval { $empty_path->cleanup() };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result->stringify(), '', 'cleanup handles empty path');
}

# Edge case: Already canonical path
my $canonical_path = Path::Class::Entity->new('a/b/c');
$result = eval { $canonical_path->cleanup() };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result->stringify(), 'a/b/c', 'cleanup handles already canonical path');
}

# Edge case: Path with multiple slashes
my $path_with_multiple_slashes = Path::Class::Entity->new('a//b//c');
$result = eval { $path_with_multiple_slashes->cleanup() };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result->stringify(), 'a/b/c', 'cleanup handles path with multiple slashes');
}

# Edge case: Path with leading and trailing slashes
my $path_with_leading_trailing_slashes = Path::Class::Entity->new('/a/b/c/');
$result = eval { $path_with_leading_trailing_slashes->cleanup() };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result->stringify(), '/a/b/c', 'cleanup handles path with leading and trailing slashes');
}

# Clean up mocks
unmock 'Path::Class::Entity';

done_testing();
