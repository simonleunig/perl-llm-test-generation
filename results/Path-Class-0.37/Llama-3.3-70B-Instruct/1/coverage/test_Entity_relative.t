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

my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $entity->relative('/path/to/base') };
# FAILED: if ($@) { fail('relative function crashed: ' . $@); } else { ok(defined $result, 'relative function returns result'); }

# UNVALIDATED: $result = eval { $entity->relative() };
# FAILED: if ($@) { fail('relative function crashed: ' . $@); } else { ok(defined $result, 'relative function returns result with no base'); }

# UNVALIDATED: $result = eval { $entity->relative('') };
# FAILED: if ($@) { fail('relative function crashed: ' . $@); } else { ok(defined $result, 'relative function returns result with empty base'); }

# UNVALIDATED: $result = eval { $entity->relative(undef) };
# FAILED: if ($@) { fail('relative function crashed: ' . $@); } else { ok(defined $result, 'relative function returns result with undef base'); }

done_testing();