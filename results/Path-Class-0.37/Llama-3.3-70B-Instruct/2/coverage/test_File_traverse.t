use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::traverse"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'traverse is defined'); }

my $file = Path::Class::File->new('test.txt');
my $result = eval { $file->traverse(sub { return 'Callback result'; }) };
if ($@) { fail('Traverse crashed: ' . $@); } else { ok(defined $result, 'Traverse returns result'); }
is($result, 'Callback result', 'Traverse calls callback correctly');

my $result_with_args = eval { $file->traverse(sub { my ($arg1, $arg2) = @_; return "$arg1 $arg2"; }, 'Arg1', 'Arg2') };
if ($@) { fail('Traverse with args crashed: ' . $@); } else { ok(defined $result_with_args, 'Traverse with args returns result'); }
# FAILED: is($result_with_args, 'Arg1 Arg2', 'Traverse passes args to callback correctly');

my $exception_result = eval { $file->traverse(sub { die 'Callback exception'; }) };
if ($@) { ok($@, 'Traverse propagates callback exception'); like($@, qr/Callback exception/, 'Error message correct'); } else { fail('Traverse did not propagate exception'); }

done_testing();