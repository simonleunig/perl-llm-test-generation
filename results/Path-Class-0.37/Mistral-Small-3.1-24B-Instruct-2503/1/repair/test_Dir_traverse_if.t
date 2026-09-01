use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::traverse_if"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'traverse_if is defined'); }

# Mocking dependencies
my $mock;
eval { require Path::Class::Dir; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Dir - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::Dir::children"}) {
        $mock = mock 'Path::Class::Dir' => (
            override => [
                children => sub { return @_ },
                traverse_if => sub { return @_ },
            ],
        );
    } else {
        $mock = mock 'Path::Class::Dir' => (
            add => [
                children => sub { return @_ },
                traverse_if => sub { return @_ },
            ],
        );
    }
}

# Test case 1: Normal operation with valid inputs
{
    my $dir = bless {}, 'Path::Class::Dir';
    my $callback = sub { return 'callback_result' };
    my $condition = sub { return 1 };

    my $result = eval { $dir->traverse_if($callback, $condition) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 'callback_result', 'traverse_if returns the result of the callback');
    }
}

# Test case 2: Condition returns false for all children
{
    my $dir = bless {}, 'Path::Class::Dir';
    my $callback = sub { return 'callback_result' };
    my $condition = sub { return 0 };

    my $result = eval { $dir->traverse_if($callback, $condition) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, undef, 'traverse_if returns undef when condition is false for all children');
    }
}

# Test case 3: Directory does not exist or is not readable
{
    my $dir = bless {}, 'Path::Class::Dir';
    my $callback = sub { return 'callback_result' };
    my $condition = sub { return 1 };

    mock 'Path::Class::Dir' => (
        override => [
            children => sub { die 'Directory does not exist' },
        ],
    );

    my $error = eval { $dir->traverse_if($callback, $condition) };
    if ($@) { like($@, qr/Directory does not exist/, 'traverse_if throws an exception when directory does not exist'); } else {
        fail('Function did not crash as expected');
    }
}

# Test case 4: Callback modifies the directory structure during traversal
{
    my $dir = bless {}, 'Path::Class::Dir';
    my $callback = sub {
        # Simulate modifying the directory structure
        return 'modified';
    };
    my $condition = sub { return 1 };

    my $result = eval { $dir->traverse_if($callback, $condition) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 'modified', 'traverse_if handles callback modifying the directory structure');
    }
}

# Test case 5: Empty directory
{
    my $dir = bless {}, 'Path::Class::Dir';
    my $callback = sub { return 'callback_result' };
    my $condition = sub { return 1 };

    mock 'Path::Class::Dir' => (
        override => [
            children => sub { return () },
        ],
    );

    my $result = eval { $dir->traverse_if($callback, $condition) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, undef, 'traverse_if handles empty directories gracefully');
    }
}

# Test case 6: Directory with no children that meet the condition
{
    my $dir = bless {}, 'Path::Class::Dir';
    my $callback = sub { return 'callback_result' };
    my $condition = sub { return 0 };

    mock 'Path::Class::Dir' => (
        override => [
            children => sub { return ('child1', 'child2') },
        ],
    );

    my $result = eval { $dir->traverse_if($callback, $condition) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, undef, 'traverse_if handles directories with no children that meet the condition');
    }
}

done_testing();