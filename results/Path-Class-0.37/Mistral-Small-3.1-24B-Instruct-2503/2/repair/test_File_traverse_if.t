use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::traverse_if"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'traverse_if is defined'); }

# Mocking dependencies
my $mock_dir;
eval { require Path::Class::Dir; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Dir - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::Dir::dir"}) {
        $mock_dir = mock 'Path::Class::Dir' => ( override => [ dir => sub { return bless {}, 'Path::Class::Dir' } ] );
    } else {
        $mock_dir = mock 'Path::Class::Dir' => ( add => [ dir => sub { return bless {}, 'Path::Class::Dir' } ] );
    }
}

my $mock_entity;
eval { require Path::Class::Entity; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Entity - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::Entity::new"}) {
        $mock_entity = mock 'Path::Class::Entity' => ( override => [ new => sub { return bless {}, 'Path::Class::Entity' } ] );
    } else {
        $mock_entity = mock 'Path::Class::Entity' => ( add => [ new => sub { return bless {}, 'Path::Class::Entity' } ] );
    }
}

# Test case 1: Normal operation with condition true
{
    my $file = bless {}, 'Path::Class::File';
    my $callback_called = 0;
    my $callback = sub { $callback_called = 1; return 'callback_result' };
    my $condition = sub { return 1 };

    my $result = eval { $file->traverse_if($callback, $condition, 'arg1', 'arg2') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(defined $result, 'Function returns result');
        is($callback_called, 1, 'Callback was called');
        is($result, 'callback_result', 'Callback result is returned');
    }
}

# Test case 2: Condition false, callback should not be called
{
    my $file = bless {}, 'Path::Class::File';
    my $callback_called = 0;
    my $callback = sub { $callback_called = 1; return 'callback_result' };
    my $condition = sub { return 0 };

    my $result = eval { $file->traverse_if($callback, $condition, 'arg1', 'arg2') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(defined $result, 'Function returns result');
        is($callback_called, 0, 'Callback was not called');
        is_deeply($result, [], 'Empty list is returned');
    }
}

# Test case 3: Invalid callback (not a subroutine reference)
{
    my $file = bless {}, 'Path::Class::File';
    my $condition = sub { return 1 };

    my $result = eval { $file->traverse_if('not_a_sub', $condition, 'arg1', 'arg2') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(defined $result, 'Function returns result');
        is_deeply($result, [], 'Empty list is returned');
    }
}

# Test case 4: Invalid condition (not a subroutine reference)
{
    my $file = bless {}, 'Path::Class::File';
    my $callback = sub { return 'callback_result' };

    my $result = eval { $file->traverse_if($callback, 'not_a_sub', 'arg1', 'arg2') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(defined $result, 'Function returns result');
        is_deeply($result, [], 'Empty list is returned');
    }
}

# Test case 5: Invalid arguments passed to callback
{
    my $file = bless {}, 'Path::Class::File';
    my $callback_called = 0;
    my $callback = sub { $callback_called = 1; return 'callback_result' };
    my $condition = sub { return 1 };

    my $result = eval { $file->traverse_if($callback, $condition, undef, 'invalid_arg') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(defined $result, 'Function returns result');
        is($callback_called, 1, 'Callback was called');
        is($result, 'callback_result', 'Callback result is returned');
    }
}

done_testing();