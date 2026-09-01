use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::traverse_if"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'traverse_if is defined'); }

my $file = Path::Class::File->new('test_file.txt');
my $callback = sub { return 'Callback executed'; };
my $condition = sub { return 1; };
my @args = ('arg1', 'arg2');
my $result = eval { $file->traverse_if($callback, $condition, @args) };
if ($@) { fail('traverse_if crashed: ' . $@); } else { ok(defined $result, 'traverse_if returns result'); }

my $invalid_callback = 'not a subroutine';
$result = eval { $file->traverse_if($invalid_callback, $condition, @args) };
if ($@) { ok(1, 'traverse_if with invalid callback throws an error'); } else { fail('traverse_if with invalid callback did not throw an error'); }

my $invalid_condition = 'not a subroutine';
$result = eval { $file->traverse_if($callback, $invalid_condition, @args) };
if ($@) { ok(1, 'traverse_if with invalid condition throws an error'); } else { fail('traverse_if with invalid condition did not throw an error'); }

my $non_existent_file = Path::Class::File->new('non_existent_file.txt');
$result = eval { $non_existent_file->traverse_if($callback, $condition, @args) };
if ($@) { ok(1, 'traverse_if with non-existent file throws an error'); } else { fail('traverse_if with non-existent file did not throw an error'); }

done_testing();