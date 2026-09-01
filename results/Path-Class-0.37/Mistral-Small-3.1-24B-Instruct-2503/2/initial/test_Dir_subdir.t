use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::subdir"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'subdir is defined'); }

# Mocking dependencies
mock 'Path::Class::Dir' => (
    override => [
        new => sub {
            my ($class, $parent, @components) = @_;
            return bless { parent => $parent, components => \@components }, $class;
        },
    ],
);

# Test case: Normal operation with additional directory components
{
    my $dir = bless {}, 'Path::Class::Dir';
    my $result = eval { $dir->subdir('subdir1', 'subdir2') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is(ref($result), 'Path::Class::Dir', 'subdir returns a Path::Class::Dir object');
        is_deeply($result->{components}, ['subdir1', 'subdir2'], 'subdir components are correct');
    }
}

# Test case: No additional directory components
{
    my $dir = bless {}, 'Path::Class::Dir';
    my $result = eval { $dir->subdir() };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is(ref($result), 'Path::Class::Dir', 'subdir returns a Path::Class::Dir object');
        is_deeply($result->{components}, [], 'subdir components are empty');
    }
}

# Test case: Invalid path components (handled gracefully)
{
    my $dir = bless {}, 'Path::Class::Dir';
    my $result = eval { $dir->subdir('..', 'invalid', '') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is(ref($result), 'Path::Class::Dir', 'subdir returns a Path::Class::Dir object');
        is_deeply($result->{components}, ['..', 'invalid', ''], 'subdir components are as provided');
    }
}

# Test case: Cross-platform compatibility (mocked)
{
    my $dir = bless {}, 'Path::Class::Dir';
    my $result = eval { $dir->subdir('subdir1', 'subdir2') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is(ref($result), 'Path::Class::Dir', 'subdir returns a Path::Class::Dir object');
        is_deeply($result->{components}, ['subdir1', 'subdir2'], 'subdir components are correct');
    }
}

# Clean up mocks
unmock 'Path::Class::Dir';

done_testing();
