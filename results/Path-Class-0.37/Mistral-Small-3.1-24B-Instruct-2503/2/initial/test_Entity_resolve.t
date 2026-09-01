use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Entity; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Entity::resolve"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'resolve is defined'); }

# Mocking external dependencies
mock 'Cwd' => (
    realpath => sub {
        my ($path) = @_;
        return File::Spec->rel2abs($path);
    }
);

mock 'Carp' => (
    croak => sub {
        my ($message) = @_;
        die $message;
    }
);

# Test case: Path does not exist
{
    my $path = Path::Class::Entity->new('nonexistent/path');
    my $result = eval { $path->resolve() };
    is($@, "$! nonexistent/path", 'resolve throws error for non-existent path');
}

# Test case: Absolute path exists
{
    my $tempdir = tempdir(CLEANUP => 1);
    my $path = Path::Class::Entity->new($tempdir);
    my $result = eval { $path->resolve() };
    is($result, $path, 'resolve returns the same object for existing absolute path');
    is($result->stringify, File::Spec->rel2abs($tempdir), 'path is resolved correctly');
}

# Test case: Relative path exists
{
    my $tempdir = tempdir(CLEANUP => 1);
    my $relative_path = 'relative/path';
    my $full_path = File::Spec->catfile($tempdir, $relative_path);
    mkdir $full_path;
    my $path = Path::Class::Entity->new($relative_path);
    my $result = eval { $path->resolve() };
    is($result, $path, 'resolve returns the same object for existing relative path');
    is($result->stringify, File::Spec->rel2abs($full_path), 'relative path is resolved correctly');
}

# Test case: Relative path converted to absolute
{
    my $tempdir = tempdir(CLEANUP => 1);
    my $relative_path = 'relative/path';
    my $full_path = File::Spec->catfile($tempdir, $relative_path);
    mkdir $full_path;
    my $path = Path::Class::Entity->new($relative_path);
    my $result = eval { $path->resolve() };
    is($result, $path, 'resolve returns the same object for relative path');
    is($result->stringify, File::Spec->rel2abs($full_path), 'relative path is resolved correctly');
}

# Test case: Path is already absolute
{
    my $tempdir = tempdir(CLEANUP => 1);
    my $path = Path::Class::Entity->new($tempdir);
    my $result = eval { $path->resolve() };
    is($result, $path, 'resolve returns the same object for absolute path');
    is($result->stringify, File::Spec->rel2abs($tempdir), 'absolute path remains unchanged');
}

done_testing();
