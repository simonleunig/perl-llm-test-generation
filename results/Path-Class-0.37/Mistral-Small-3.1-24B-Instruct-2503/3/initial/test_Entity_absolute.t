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

# Mocking dependencies
mock 'Path::Class::Entity' => (
    override => [
        is_absolute => sub { return shift->{is_absolute} },
        _spec => sub { return File::Spec->new },
        new => sub { return bless { stringify => shift }, 'Path::Class::Entity' },
        stringify => sub { return shift->{stringify} },
    ]
);

# Test case: Path is already absolute
{
    my $entity = bless { is_absolute => 1, stringify => '/absolute/path' }, 'Path::Class::Entity';
    my $result = eval { $entity->absolute };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, $entity, 'absolute returns the same object if path is already absolute');
    }
}

# Test case: Path is relative and needs to be converted to absolute
{
    my $relative_path = 'relative/path';
    my $absolute_path = File::Spec->new->rel2abs($relative_path);
    my $entity = bless { is_absolute => 0, stringify => $relative_path }, 'Path::Class::Entity';

    my $result = eval { $entity->absolute };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result->{stringify}, $absolute_path, 'absolute converts relative path to absolute path');
    }
}

# Test case: Invalid path (handled by other methods)
{
    my $invalid_path = 'invalid/path';
    my $entity = bless { is_absolute => 0, stringify => $invalid_path }, 'Path::Class::Entity';

    my $result = eval { $entity->absolute };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(1, 'absolute handles invalid paths gracefully');
    }
}

# Clean up mocks
unmock 'Path::Class::Entity';

done_testing();
