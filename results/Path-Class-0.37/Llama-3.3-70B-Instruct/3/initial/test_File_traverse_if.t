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

# Test case 1: Test with valid callback and condition
my $file = Path::Class::File->new('test.txt');
my $callback = sub { return 'Callback executed'; };
my $condition = sub { return 1; };
my @args = ('arg1', 'arg2');
my $result = eval { $file->traverse_if($callback, $condition, @args) };
if ($@) { fail('traverse_if crashed: ' . $@); } else { ok(defined $result, 'traverse_if returns result with valid callback and condition'); }

# Test case 2: Test with invalid callback
$file = Path::Class::File->new('test.txt');
$callback = 'invalid_callback';
$condition = sub { return 1; };
@args = ('arg1', 'arg2');
$result = eval { $file->traverse_if($callback, $condition, @args) };
if ($@) { ok($@, 'traverse_if crashes with invalid callback'); } else { fail('traverse_if did not crash with invalid callback'); }

# Test case 3: Test with invalid condition
$file = Path::Class::File->new('test.txt');
$callback = sub { return 'Callback executed'; };
$condition = 'invalid_condition';
@args = ('arg1', 'arg2');
$result = eval { $file->traverse_if($callback, $condition, @args) };
if ($@) { ok($@, 'traverse_if crashes with invalid condition'); } else { fail('traverse_if did not crash with invalid condition'); }

# Test case 4: Test with no args
$file = Path::Class::File->new('test.txt');
$callback = sub { return 'Callback executed'; };
$condition = sub { return 1; };
$result = eval { $file->traverse_if($callback, $condition) };
if ($@) { fail('traverse_if crashed: ' . $@); } else { ok(defined $result, 'traverse_if returns result with no args'); }

done_testing();
