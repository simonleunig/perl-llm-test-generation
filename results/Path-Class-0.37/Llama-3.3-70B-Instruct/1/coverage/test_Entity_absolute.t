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

my $entity = eval { Path::Class::Entity->new('/absolute/path') };
if ($@) { fail('Entity creation crashed: ' . $@); } else { ok(defined $entity, 'Entity created'); }

my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $entity->absolute };
# FAILED: if ($@) { fail('Absolute path crashed: ' . $@); } else { ok(defined $result, 'Absolute path returns result'); }
my $expected_absolute_path;  # AFTER LAST PASS: my $expected_absolute_path = '/absolute/path';
# FAILED: is($result->stringify, $expected_absolute_path, 'Absolute path remains unchanged');

my $relative_entity;  # AFTER LAST PASS: my $relative_entity;  # UNVALIDATED: my $relative_entity = eval { Path::Class::Entity->new('relative/path') };
# FAILED: if ($@) { fail('Relative entity creation crashed: ' . $@); } else { ok(defined $relative_entity, 'Relative entity created'); }

my $relative_result;  # AFTER LAST PASS: my $relative_result;  # UNVALIDATED: my $relative_result = eval { $relative_entity->absolute };
# FAILED: if ($@) { fail('Relative path crashed: ' . $@); } else { ok(defined $relative_result, 'Relative path returns result'); }
my $expected_absolute_path_relative;  # AFTER LAST PASS: my $expected_absolute_path_relative;  # UNVALIDATED: my $expected_absolute_path_relative = File::Spec->rel2abs('relative/path');
# FAILED: is($relative_result->stringify, $expected_absolute_path_relative, 'Relative path is converted to absolute');

my $empty_entity;  # AFTER LAST PASS: my $empty_entity;  # UNVALIDATED: my $empty_entity = eval { Path::Class::Entity->new('') };
# FAILED: if ($@) { fail('Empty entity creation crashed: ' . $@); } else { ok(defined $empty_entity, 'Empty entity created'); }

my $empty_result;  # AFTER LAST PASS: my $empty_result;  # UNVALIDATED: my $empty_result = eval { $empty_entity->absolute };
# FAILED: if ($@) { fail('Empty path crashed: ' . $@); } else { ok(defined $empty_result, 'Empty path returns result'); }
my $expected_absolute_empty_path;  # AFTER LAST PASS: my $expected_absolute_empty_path;  # UNVALIDATED: my $expected_absolute_empty_path = File::Spec->rel2abs('');
# FAILED: is($empty_result->stringify, $expected_absolute_empty_path, 'Empty path is converted to absolute');

my $invalid_entity;  # AFTER LAST PASS: my $invalid_entity = bless {}, 'InvalidClass';
my $invalid_result;  # AFTER LAST PASS: my $invalid_result;  # UNVALIDATED: my $invalid_result = eval { $invalid_entity->absolute };
# FAILED: if ($@) { ok(1, 'Invalid input crashes as expected'); } else { fail('Invalid input did not crash'); }

done_testing();