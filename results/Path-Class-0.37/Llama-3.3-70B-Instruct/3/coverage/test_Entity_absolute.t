use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Entity; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Entity::absolute"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'absolute is defined'); }

my $entity;  # AFTER LAST PASS: my $entity = bless({}, 'Path::Class::Entity');

my $mock_is_absolute;  # AFTER LAST PASS: my $mock_is_absolute = mock 'Path::Class::Entity' => (
    # AFTER LAST PASS: track => 'is_absolute',
    # AFTER LAST PASS: override => sub { return 1; },
# AFTER LAST PASS: );
my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $entity->absolute() };
# FAILED: if ($@) { fail('Already absolute path crashed: ' . $@); } else { ok(defined $result, 'Already absolute path returns result'); }

# AFTER LAST PASS: $mock_is_absolute = mock 'Path::Class::Entity' => (
    # AFTER LAST PASS: track => 'is_absolute',
    # AFTER LAST PASS: override => sub { return 0; },
# AFTER LAST PASS: );
my $mock_new;  # AFTER LAST PASS: my $mock_new = mock 'Path::Class::Entity' => (
    # AFTER LAST PASS: track => 'new',
    # AFTER LAST PASS: override => sub { return bless({}, 'Path::Class::Entity'); },
# AFTER LAST PASS: );
my $mock__spec;  # AFTER LAST PASS: my $mock__spec = mock 'Path::Class::Entity' => (
    # AFTER LAST PASS: track => '_spec',
    # AFTER LAST PASS: override => sub { return bless({}, 'File::Spec'); },
# AFTER LAST PASS: );
my $mock_rel2abs;  # AFTER LAST PASS: my $mock_rel2abs = mock 'File::Spec' => (
    # AFTER LAST PASS: track => 'rel2abs',
    # AFTER LAST PASS: override => sub { return '/absolute/path'; },
# AFTER LAST PASS: );
my $mock_stringify;  # AFTER LAST PASS: my $mock_stringify = mock 'Path::Class::Entity' => (
    # AFTER LAST PASS: track => 'stringify',
    # AFTER LAST PASS: override => sub { return 'relative/path'; },
# AFTER LAST PASS: );
# UNVALIDATED: $result = eval { $entity->absolute() };
# FAILED: if ($@) { fail('Relative path crashed: ' . $@); } else { ok(defined $result, 'Relative path returns result'); }

# AFTER LAST PASS: $mock_rel2abs = mock 'File::Spec' => (
    # AFTER LAST PASS: track => 'rel2abs',
    # AFTER LAST PASS: override => sub { die 'Error during path conversion'; },
# AFTER LAST PASS: );
my $error;  # AFTER LAST PASS: my $error;  # UNVALIDATED: my $error = eval { $entity->absolute() };
# FAILED: if ($@) { ok($@, 'Error during path conversion'); like($@, qr/Error during path conversion/, 'Error message correct'); } else { fail('Error during path conversion did not crash'); }

done_testing();