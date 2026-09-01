use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::relative"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'relative is defined'); }

# Mocking dependencies
mock 'Path::Class::Entity' => (
    override => [
        new => sub { return bless {}, 'Path::Class::Dir' },
        stringify => sub { return shift->[0] },
        _spec => sub { return bless {}, 'File::Spec' },
    ],
);

mock 'File::Spec' => (
    override => [
        abs2rel => sub {
            my ($self, $path1, $path2) = @_;
            return $path1 eq $path2 ? '' : $path2;
        },
        curdir => sub { return '.' },
    ],
);

# Test case: Paths are equal
{
    my $dir = bless ['/path/to/dir'], 'Path::Class::Dir';
    my $result = eval { $dir->relative('/path/to/dir') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result->stringify, '.', 'Returns current directory when paths are equal');
    }
}

# Test case: Paths are different
{
    my $dir = bless ['/path/to/dir'], 'Path::Class::Dir';
    my $result = eval { $dir->relative('/another/path') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result->stringify, '/another/path', 'Returns relative path when paths are different');
    }
}

# Test case: No base directory specified
{
    my $dir = bless ['/path/to/dir'], 'Path::Class::Dir';
    my $result = eval { $dir->relative() };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result->stringify, '.', 'Returns current directory when no base directory is specified');
    }
}

# Test case: Edge case with empty string
{
    my $dir = bless ['/path/to/dir'], 'Path::Class::Dir';
    my $result = eval { $dir->relative('/path/to/dir', '/path/to/dir') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result->stringify, '.', 'Returns current directory when paths are equal');
    }
}

done_testing();
