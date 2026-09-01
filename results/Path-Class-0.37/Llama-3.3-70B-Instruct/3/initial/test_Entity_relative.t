use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Entity; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Entity::relative"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'relative is defined'); }

# Test case 1: Successful relative path calculation
my $entity = Path::Class::Entity->new('/path/to/entity');
my $result = eval { $entity->relative('/path/to/base') };
if ($@) { fail('Relative path calculation crashed: ' . $@); } else { ok(defined $result, 'Relative path calculation returns result'); }

# Test case 2: Error handling - invalid base directory
my $invalid_base = eval { $entity->relative('invalid/base') };
if ($@) { ok($@, 'Invalid base directory raises error'); } else { fail('Invalid base directory did not raise error'); }

# Test case 3: Edge case - current entity is already relative
my $relative_entity = Path::Class::Entity->new('relative/entity');
my $relative_result = eval { $relative_entity->relative('/path/to/base') };
if ($@) { fail('Relative entity calculation crashed: ' . $@); } else { ok(defined $relative_result, 'Relative entity calculation returns result'); }

# Test case 4: Edge case - base directory is the same as the current entity
my $same_base_result = eval { $entity->relative('/path/to/entity') };
if ($@) { fail('Same base calculation crashed: ' . $@); } else { ok(defined $same_base_result, 'Same base calculation returns result'); }

done_testing();
