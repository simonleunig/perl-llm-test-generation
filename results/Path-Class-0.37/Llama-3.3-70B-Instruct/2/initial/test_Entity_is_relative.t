use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Entity; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Entity::is_relative"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'is_relative is defined'); }

# Test case 1: Relative path
my $entity = bless({}, 'Path::Class::Entity');
my $mock = mock 'Path::Class::Entity' => (
    is_absolute => sub { return 0; },
);
my $result = eval { $entity->is_relative() };
if ($@) { fail('Function crashed: ' . $@); } else { ok($result, 'Relative path returns true'); }

# Test case 2: Absolute path
$mock = mock 'Path::Class::Entity' => (
    is_absolute => sub { return 1; },
);
$result = eval { $entity->is_relative() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!$result, 'Absolute path returns false'); }

# Test case 3: Error handling
$mock = mock 'Path::Class::Entity' => (
    is_absolute => sub { die 'Mock error'; },
);
$result = eval { $entity->is_relative() };
if ($@) { ok(1, 'Error handling works'); } else { fail('Error handling failed'); }

done_testing();
