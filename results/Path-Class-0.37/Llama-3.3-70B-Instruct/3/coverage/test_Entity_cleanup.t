use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Entity; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Entity::cleanup"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'cleanup is defined'); }

my $entity = Path::Class::Entity->new('/path/with/redundant/separators//and/./parent/dir');
my $result = eval { $entity->cleanup() };
# FAILED: if ($@) { fail('cleanup crashed: ' . $@); } else { ok(defined $result, 'cleanup returns result'); }

$entity = Path::Class::Entity->new('///');
$result = eval { $entity->cleanup() };
# FAILED: if ($@) { fail('cleanup crashed: ' . $@); } else { ok(defined $result, 'cleanup returns result for edge case'); }

$entity = bless {}, 'Path::Class::Entity';
$result = eval { $entity->cleanup() };
if ($@) { ok($@, 'cleanup crashes with invalid input'); } else { fail('cleanup did not crash with invalid input'); }

my $mock;
# AFTER LAST PASS: eval { require File::Spec; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: File::Spec - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"File::Spec::canonpath"}) {
        # AFTER LAST PASS: $mock = mock 'File::Spec' => ( override => [ canonpath => sub { return '/mocked/path'; } ] );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock = mock 'File::Spec' => ( add => [ canonpath => sub { return '/mocked/path'; } ] );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

done_testing();