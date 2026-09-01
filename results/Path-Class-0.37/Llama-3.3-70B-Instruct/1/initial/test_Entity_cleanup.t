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
my $entity = Path::Class::Entity->new('/path/to/directory');
my $result = eval { $entity->cleanup() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'cleanup returns result for normal path'); }

# Test case 2: Edge case - empty path
$entity = Path::Class::Entity->new('');
$result = eval { $entity->cleanup() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'cleanup returns result for empty path'); }

# Test case 3: Edge case - path with redundant components
$entity = Path::Class::Entity->new('/path/to/directory/../');
$result = eval { $entity->cleanup() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'cleanup returns result for path with redundant components'); }

# Test case 4: Error handling - invalid system type
mock 'File::Spec' => (
    canonpath => sub { die 'Invalid system type' },
);
$entity = Path::Class::Entity->new('/path/to/directory');
$result = eval { $entity->cleanup() };
if ($@) { ok($@ =~ /Invalid system type/, 'cleanup raises exception for invalid system type'); } else { fail('Function did not crash as expected'); }

done_testing();
