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
mock 'Path::Class::Dir' => ( dir => sub { return bless {}, 'Path::Class::Dir' } );
mock 'Path::Class::Entity' => ( new => sub { return bless {}, 'Path::Class::Entity' } );
mock 'Carp' => ( croak => sub { die shift } );
mock 'IO::File' => ( new => sub { return bless {}, 'IO::File' } );
mock 'Perl::OSType' => ();
mock 'File::Copy' => ();

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
    my $callback = 'not_a_sub';
    my $condition = sub { return 1 };

    my $result = eval { $file->traverse_if($callback, $condition, 'arg1', 'arg2') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(defined $result, 'Function returns result');
        is_deeply($result, [], 'Empty list is returned');
    }
}

# Test case 4: Invalid condition (not a subroutine reference)
{
    my $file = bless {}, 'Path::Class::File';
    my $callback = sub { return 'callback_result' };
    my $condition = 'not_a_sub';

    my $result = eval { $file->traverse_if($callback, $condition, 'arg1', 'arg2') };
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
