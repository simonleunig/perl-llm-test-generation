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
if ($@) { fail('cleanup crashed: ' . $@); } else { ok(defined $result, 'cleanup returns result'); }

$entity = Path::Class::Entity->new('///');
$result = eval { $entity->cleanup() };
if ($@) { fail('cleanup crashed: ' . $@); } else { ok(defined $result, 'cleanup returns result for edge case'); }

$entity = bless {}, 'Path::Class::Entity';
$result = eval { $entity->cleanup() };
if ($@) { ok($@, 'cleanup crashes with invalid input'); } else { fail('cleanup did not crash with invalid input'); }

my $mock;
eval { require File::Spec; };
if ($@) {
    # DEPENDENCY MISSING: File::Spec - mock skipped
} else {
    no strict 'refs';
    if (defined &{"File::Spec::canonpath"}) {
        $mock = mock 'File::Spec' => ( override => [ canonpath => sub { return '/mocked/path'; } ] );
    } else {
        $mock = mock 'File::Spec' => ( add => [ canonpath => sub { return '/mocked/path'; } ] );
    }
}

done_testing();