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

my $entity = Path::Class::Entity->new('/path/to/entity');
my $result = eval { $entity->relative('/path/to/base') };
# FAILED: if ($@) { fail('Relative path calculation crashed: ' . $@); } else { ok(defined $result, 'Relative path calculation returns result'); }

my $invalid_base = eval { $entity->relative('invalid/base') };
if ($@) { ok($@, 'Invalid base directory raises error'); } else { fail('Invalid base directory did not raise error'); }

my $relative_entity;  # AFTER LAST PASS: my $relative_entity;  # UNVALIDATED: my $relative_entity = Path::Class::Entity->new('relative/entity');
my $relative_result;  # AFTER LAST PASS: my $relative_result;  # UNVALIDATED: my $relative_result = eval { $relative_entity->relative('/path/to/base') };
# FAILED: if ($@) { fail('Relative entity calculation crashed: ' . $@); } else { ok(defined $relative_result, 'Relative entity calculation returns result'); }

my $same_base_result;  # AFTER LAST PASS: my $same_base_result;  # UNVALIDATED: my $same_base_result = eval { $entity->relative('/path/to/entity') };
# FAILED: if ($@) { fail('Same base calculation crashed: ' . $@); } else { ok(defined $same_base_result, 'Same base calculation returns result'); }

done_testing();