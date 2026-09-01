use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Entity; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Entity::relative"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'relative is defined'); }

my $entity = eval { Path::Class::Entity->new('/path/to/entity') };
if ($@) { fail('Entity creation crashed: ' . $@); } else { ok(defined $entity, 'Entity created'); }

my $result = eval { $entity->relative('/path/to/base') };
if ($@) { fail('relative function crashed: ' . $@); } else { ok(defined $result, 'relative function returns result'); }

$result = eval { $entity->relative() };
if ($@) { fail('relative function crashed: ' . $@); } else { ok(defined $result, 'relative function returns result with no base'); }

$result = eval { $entity->relative('') };
if ($@) { fail('relative function crashed: ' . $@); } else { ok(defined $result, 'relative function returns result with empty base'); }

$result = eval { $entity->relative(undef) };
if ($@) { fail('relative function crashed: ' . $@); } else { ok(defined $result, 'relative function returns result with undef base'); }

done_testing();