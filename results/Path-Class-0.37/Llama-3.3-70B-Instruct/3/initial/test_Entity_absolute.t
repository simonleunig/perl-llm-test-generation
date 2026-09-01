use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Entity; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Entity::absolute"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'absolute is defined'); }

# Test case: Already absolute path
my $entity = bless({}, 'Path::Class::Entity');
my $mock_is_absolute = mock 'Path::Class::Entity' => (
    track => 'is_absolute',
    override => sub { return 1; },
);
my $result = eval { $entity->absolute() };
if ($@) { fail('Already absolute path crashed: ' . $@); } else { ok(defined $result, 'Already absolute path returns result'); }

# Test case: Relative path
$mock_is_absolute = mock 'Path::Class::Entity' => (
    track => 'is_absolute',
    override => sub { return 0; },
);
my $mock_new = mock 'Path::Class::Entity' => (
    track => 'new',
    override => sub { return bless({}, 'Path::Class::Entity'); },
);
my $mock__spec = mock 'Path::Class::Entity' => (
    track => '_spec',
    override => sub { return bless({}, 'File::Spec'); },
);
my $mock_rel2abs = mock 'File::Spec' => (
    track => 'rel2abs',
    override => sub { return '/absolute/path'; },
);
my $mock_stringify = mock 'Path::Class::Entity' => (
    track => 'stringify',
    override => sub { return 'relative/path'; },
);
$result = eval { $entity->absolute() };
if ($@) { fail('Relative path crashed: ' . $@); } else { ok(defined $result, 'Relative path returns result'); }

# Test case: Error during path conversion
$mock_rel2abs = mock 'File::Spec' => (
    track => 'rel2abs',
    override => sub { die 'Error during path conversion'; },
);
$result = eval { $entity->absolute() };
if ($@) { ok($@, 'Error during path conversion'); } else { fail('Error during path conversion did not crash'); }

done_testing();
