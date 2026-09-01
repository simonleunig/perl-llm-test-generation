use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Entity; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Entity::new_foreign"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'new_foreign is defined'); }

# Test case: Valid type
my $result = eval { Path::Class::Entity->new_foreign('Unix') };
if ($@) { fail('new_foreign crashed with valid type: ' . $@); } else { ok(defined $result, 'new_foreign returns result with valid type'); }

# Test case: Invalid type
$result = eval { Path::Class::Entity->new_foreign('InvalidType') };
if ($@) { ok(1, 'new_foreign throws exception with invalid type'); } else { fail('new_foreign did not throw exception with invalid type'); }

# Test case: Edge case - empty type
$result = eval { Path::Class::Entity->new_foreign('') };
if ($@) { ok(1, 'new_foreign throws exception with empty type'); } else { fail('new_foreign did not throw exception with empty type'); }

# Test case: Edge case - undefined type
$result = eval { Path::Class::Entity->new_foreign(undef) };
if ($@) { ok(1, 'new_foreign throws exception with undefined type'); } else { fail('new_foreign did not throw exception with undefined type'); }

done_testing();
