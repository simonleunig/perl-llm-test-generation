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
my $result = eval { $file->traverse(sub { 'callback result' }) };
if ($@) { fail('traverse crashed: ' . $@); } else { ok(defined $result, 'traverse returns result with valid callback'); }

$result = eval { $file->traverse('invalid_callback') };
if ($@) { ok(1, 'traverse dies with invalid callback'); } else { fail('traverse did not die with invalid callback'); }

my $callback;  # AFTER LAST PASS: my $callback = sub { my ($self, @args) = @_; return join(', ', @args) };
# UNVALIDATED: $result = eval { $file->traverse($callback, 'arg1', 'arg2') };
# FAILED: if ($@) { fail('traverse crashed: ' . $@); } else { is($result, 'arg1, arg2', 'traverse passes arguments to callback'); }

my $mock;
# AFTER LAST PASS: eval { require Path::Class::Dir; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: Path::Class::Dir - mock skipped  
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"Path::Class::Dir::dir"}) {
        # AFTER LAST PASS: $mock = mock 'Path::Class::Dir' => ( override => [ dir => sub { Path::Class::Dir->new('mock_dir') } ] );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock = mock 'Path::Class::Dir' => ( add => [ dir => sub { Path::Class::Dir->new('mock_dir') } ] );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

done_testing();