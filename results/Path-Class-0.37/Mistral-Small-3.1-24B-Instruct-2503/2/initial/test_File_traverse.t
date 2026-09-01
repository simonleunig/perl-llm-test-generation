use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::traverse"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'traverse is defined'); }

# Mocking dependencies
mock 'Path::Class::Entity' => (
    override => [
        'dir' => sub { return 'mocked_dir' },
    ],
);

# Test case 1: Normal operation with a valid callback
{
    my $file = bless {}, 'Path::Class::File';
    my $callback = sub { return 'callback_result' };
    my $result = eval { $file->traverse($callback) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 'callback_result', 'traverse returns the result of the callback');
    }
}

# Test case 2: Callback with additional arguments
{
    my $file = bless {}, 'Path::Class::File';
    my $callback = sub { my ($arg1, $arg2) = @_; return "$arg1 $arg2" };
    my $result = eval { $file->traverse($callback, 'arg1', 'arg2') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 'arg1 arg2', 'traverse passes additional arguments to the callback');
    }
}

# Test case 3: Callback that throws an exception
{
    my $file = bless {}, 'Path::Class::File';
    my $callback = sub { die 'callback error' };
    my $result = eval { $file->traverse($callback) };
    if ($@) {
        like($@, qr/callback error/, 'traverse handles callback exceptions');
    } else {
        fail('Function did not crash as expected');
    }
}

# Test case 4: Invalid callback (not a subroutine reference)
{
    my $file = bless {}, 'Path::Class::File';
    my $result = eval { $file->traverse('not_a_sub') };
    if ($@) {
        like($@, qr/Can't use string as a subroutine ref/, 'traverse handles invalid callback');
    } else {
        fail('Function did not crash as expected');
    }
}

# Clean up mocks
unmock 'Path::Class::Entity';

done_testing();
