use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock unmock/;
use File::Temp qw/tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::traverse_if"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'traverse_if is defined'); }

# Mocking dependencies
mock 'Path::Class::Dir', 'children' => sub {
    my $self = shift;
    return @_;
};

mock 'Path::Class::Dir', 'traverse_if' => sub {
    my $self = shift;
    my ($callback, $condition, @args) = @_;
    return $self->$callback(@args);
};

# Test case 1: Normal operation with valid inputs
{
    my $dir = bless {}, 'Path::Class::Dir';
    my $callback = sub { return 'processed' };
    my $condition = sub { return 1 };

    my $result = eval { $dir->traverse_if($callback, $condition) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 'processed', 'traverse_if processes valid inputs correctly');
    }
}

# Test case 2: Condition returns false for all children
{
    my $dir = bless {}, 'Path::Class::Dir';
    my $callback = sub { return 'processed' };
    my $condition = sub { return 0 };

    my $result = eval { $dir->traverse_if($callback, $condition) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, undef, 'traverse_if handles condition returning false for all children');
    }
}

# Test case 3: Directory does not exist or is not readable
{
    my $dir = bless {}, 'Path::Class::Dir';
    my $callback = sub { return 'processed' };
    my $condition = sub { return 1 };

    mock 'Path::Class::Dir', 'children' => sub {
        die "Directory does not exist";
    };

    my $result = eval { $dir->traverse_if($callback, $condition) };
    if ($@) { like($@, qr/Directory does not exist/, 'traverse_if handles non-existent directory'); } else {
        fail('Function did not crash as expected');
    }
}

# Test case 4: Callback modifies the directory structure during traversal
{
    my $dir = bless {}, 'Path::Class::Dir';
    my $callback = sub {
        my $self = shift;
        $self->children([]);
        return 'processed';
    };
    my $condition = sub { return 1 };

    my $result = eval { $dir->traverse_if($callback, $condition) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 'processed', 'traverse_if handles callback modifying directory structure');
    }
}

# Test case 5: Empty directory
{
    my $dir = bless {}, 'Path::Class::Dir';
    my $callback = sub { return 'processed' };
    my $condition = sub { return 1 };

    mock 'Path::Class::Dir', 'children' => sub {
        return ();
    };

    my $result = eval { $dir->traverse_if($callback, $condition) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, undef, 'traverse_if handles empty directory');
    }
}

# Clean up mocks
unmock 'Path::Class::Dir';

done_testing();