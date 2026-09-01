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

# Test case: valid callback
my $file = Path::Class::File->new('test.txt');
my $result = eval { $file->traverse(sub { 'callback result' }) };
if ($@) { fail('traverse crashed: ' . $@); } else { ok(defined $result, 'traverse returns result with valid callback'); }

# Test case: invalid callback
$result = eval { $file->traverse('invalid_callback') };
if ($@) { ok(1, 'traverse dies with invalid callback'); } else { fail('traverse did not die with invalid callback'); }

# Test case: callback with arguments
my $callback = sub { my ($self, @args) = @_; return join(', ', @args) };
$result = eval { $file->traverse($callback, 'arg1', 'arg2') };
if ($@) { fail('traverse crashed: ' . $@); } else { is($result, 'arg1, arg2', 'traverse passes arguments to callback'); }

done_testing();
