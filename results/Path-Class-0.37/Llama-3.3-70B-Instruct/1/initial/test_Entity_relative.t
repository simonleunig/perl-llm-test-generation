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

# Test case 1: Test relative function with valid input
my $entity = Path::Class::Entity->new('/path/to/entity');
my $result = eval { $entity->relative('/path/to/base') };
if ($@) { fail('relative function crashed: ' . $@); } else { ok(defined $result, 'relative function returns result'); }

# Test case 2: Test relative function with invalid input
$result = eval { $entity->relative() };
if ($@) { fail('relative function crashed: ' . $@); } else { ok(defined $result, 'relative function returns result with no base'); }

# Test case 3: Test relative function with edge case (empty string)
$result = eval { $entity->relative('') };
if ($@) { fail('relative function crashed: ' . $@); } else { ok(defined $result, 'relative function returns result with empty base'); }

# Test case 4: Test relative function with edge case (undef)
$result = eval { $entity->relative(undef) };
if ($@) { fail('relative function crashed: ' . $@); } else { ok(defined $result, 'relative function returns result with undef base'); }

done_testing();
