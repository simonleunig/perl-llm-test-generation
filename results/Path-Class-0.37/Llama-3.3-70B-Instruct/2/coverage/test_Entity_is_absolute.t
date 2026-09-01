use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Entity; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Entity::is_absolute"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'is_absolute is defined'); }

my $entity;  # AFTER LAST PASS: my $entity;  # UNVALIDATED: my $entity = Path::Class::Entity->new('/absolute/path');
my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $entity->is_absolute() };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'is_absolute returns result'); }
# FAILED: is($result, 1, 'Absolute path returns true');

# UNVALIDATED: $entity = Path::Class::Entity->new('relative/path');
# UNVALIDATED: $result = eval { $entity->is_absolute() };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'is_absolute returns result'); }
# FAILED: is($result, 0, 'Relative path returns false');

# UNVALIDATED: $entity = Path::Class::Entity->new('');
# UNVALIDATED: $result = eval { $entity->is_absolute() };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'is_absolute returns result'); }
# FAILED: is($result, 0, 'Empty path returns false');

my $undefined_entity;
# UNVALIDATED: $result = eval { $undefined_entity->is_absolute() };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result, 'Undefined entity returns undefined'); }

done_testing();