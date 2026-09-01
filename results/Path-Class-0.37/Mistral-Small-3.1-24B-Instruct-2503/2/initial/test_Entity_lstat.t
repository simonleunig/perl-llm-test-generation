use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Entity; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Entity::lstat"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'lstat is defined'); }

# Mock File::stat::lstat to avoid actual file system operations
mock 'File::stat', lstat => sub {
    my ($path) = @_;
    return bless { path => $path }, 'File::stat';
};

# Test case: Valid path
{
    my $path = 'valid/path';
    my $result = eval { Path::Class::Entity::lstat($path) };
    if ($@) {
        fail('Function crashed: ' . $@);
    } else {
        ok(defined $result, 'lstat returns result for valid path');
        is($result->{path}, $path, 'lstat returns correct path');
    }
}

# Test case: Non-existent path
{
    my $path = 'non/existent/path';
    my $result = eval { Path::Class::Entity::lstat($path) };
    if ($@) {
        ok(1, 'lstat throws exception for non-existent path');
    } else {
        fail('lstat did not throw exception for non-existent path');
    }
}

# Test case: Symbolic link path
{
    my $path = 'symlink/path';
    my $result = eval { Path::Class::Entity::lstat($path) };
    if ($@) {
        ok(1, 'lstat throws exception for symbolic link path');
    } else {
        fail('lstat did not throw exception for symbolic link path');
    }
}

# Test case: Directory path
{
    my $path = 'directory/path';
    my $result = eval { Path::Class::Entity::lstat($path) };
    if ($@) {
        fail('Function crashed: ' . $@);
    } else {
        ok(defined $result, 'lstat returns result for directory path');
        is($result->{path}, $path, 'lstat returns correct path for directory');
    }
}

# Clean up mocks
unmock 'File::stat';

done_testing();
