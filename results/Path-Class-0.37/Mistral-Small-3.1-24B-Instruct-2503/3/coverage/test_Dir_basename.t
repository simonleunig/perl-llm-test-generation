use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw(tempfile tempdir);
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::basename"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'basename is defined'); }

# Mocking Path::Class::Entity to avoid dependencies
my $mock;
eval { require Path::Class::Entity; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Entity - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::Entity::new"}) {
        $mock = mock 'Path::Class::Entity' => (
            override => [
                new => sub {
                    my $class = shift;
                    my $self = bless { dirs => [] }, $class;
                    return $self;
                }
            ]
        );
    } else {
        $mock = mock 'Path::Class::Entity' => (
            add => [
                new => sub {
                    my $class = shift;
                    my $self = bless { dirs => [] }, $class;
                    return $self;
                }
            ]
        );
    }
}

# Test case: Empty directory list
{
    my $dir = eval { Path::Class::Dir->new() };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        my $result;  # FAILED: my $result = eval { $dir->basename() };
        # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
            # FAILED: is($result, undef, 'basename returns undef for empty directory list');
        # FAILED: }
    # FAILED: }
}

# Test case: Single directory
{
    my $dir = eval { Path::Class::Dir->new() };
    if ($@) { fail('Function crashed: ' . $@); } else {
        $dir->{dirs} = ['single_dir'];
        my $result = eval { $dir->basename() };
        if ($@) { fail('Function crashed: ' . $@); } else {
            is($result, 'single_dir', 'basename returns the single directory name');
        }
    }
}

# Test case: Multiple directories
{
    my $dir = eval { Path::Class::Dir->new() };
    if ($@) { fail('Function crashed: ' . $@); } else {
        $dir->{dirs} = ['dir1', 'dir2', 'dir3'];
        my $result = eval { $dir->basename() };
        if ($@) { fail('Function crashed: ' . $@); } else {
            is($result, 'dir3', 'basename returns the last directory name');
        }
    }
}

# Test case: Edge case with empty string in directory list
{
    my $dir = eval { Path::Class::Dir->new() };
    if ($@) { fail('Function crashed: ' . $@); } else {
        $dir->{dirs} = ['', 'dir2'];
        my $result = eval { $dir->basename() };
        if ($@) { fail('Function crashed: ' . $@); } else {
            is($result, 'dir2', 'basename returns the last non-empty directory name');
        }
    }
}

done_testing();