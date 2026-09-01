use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Entity; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Entity::absolute"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'absolute is defined'); }

my $entity = Path::Class::Entity->new('/absolute/path');
my $result = eval { $entity->absolute };
if ($@) { fail('Absolute path crashed: ' . $@); } else { is($result, $entity, 'Already absolute path returns original entity'); }

my $relative_entity = Path::Class::Entity->new('relative/path');
my $absolute_result = eval { $relative_entity->absolute };
if ($@) { fail('Relative path crashed: ' . $@); } else { ok(defined $absolute_result, 'Relative path returns absolute entity'); }

my $empty_entity = Path::Class::Entity->new('');
my $empty_result = eval { $empty_entity->absolute };
if ($@) { fail('Empty path crashed: ' . $@); } else { ok(defined $empty_result, 'Empty path returns absolute entity'); }

my $invalid_entity = bless {}, 'InvalidEntity';
my $invalid_result = eval { $invalid_entity->absolute };
if ($@) { ok($@, 'Invalid input crashes with error'); } else { fail('Invalid input did not crash'); }

done_testing();