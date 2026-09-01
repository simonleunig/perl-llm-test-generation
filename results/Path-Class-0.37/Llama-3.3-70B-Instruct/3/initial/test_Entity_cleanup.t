use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Entity; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Entity::cleanup"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'cleanup is defined'); }

# Test case 1: Normal path cleanup
my $entity = Path::Class::Entity->new('/path/with/redundant/separators//and/./parent/dir');
my $result = eval { $entity->cleanup() };
if ($@) { fail('cleanup crashed: ' . $@); } else { ok(defined $result, 'cleanup returns result'); }

# Test case 2: Edge case - path with only redundant separators
$entity = Path::Class::Entity->new('///');
$result = eval { $entity->cleanup() };
if ($@) { fail('cleanup crashed: ' . $@); } else { ok(defined $result, 'cleanup returns result for edge case'); }

# Test case 3: Error handling - invalid input
$entity = bless {}, 'InvalidClass';
$result = eval { $entity->cleanup() };
if ($@) { ok($@, 'cleanup crashes with invalid input'); } else { fail('cleanup did not crash with invalid input'); }

done_testing();
