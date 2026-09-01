use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Entity; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Entity::is_absolute"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'is_absolute is defined'); }

# Test case 1: Absolute path
my $entity = Path::Class::Entity->new('/absolute/path');
my $result = eval { $entity->is_absolute() };
if ($@) { fail('Function crashed: ' . $@); } else { ok($result, 'Absolute path returns true'); }

# Test case 2: Relative path
$entity = Path::Class::Entity->new('relative/path');
$result = eval { $entity->is_absolute() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!$result, 'Relative path returns false'); }

# Test case 3: Edge case - empty path
$entity = Path::Class::Entity->new('');
$result = eval { $entity->is_absolute() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!$result, 'Empty path returns false'); }

# Test case 4: Error handling - invalid input
$result = eval { Path::Class::Entity::is_absolute('invalid input') };
if ($@) { ok(1, 'Invalid input throws an error'); } else { fail('Invalid input did not throw an error'); }

done_testing();
