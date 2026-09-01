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

# Mock the is_absolute method
my $mock;
eval { require Path::Class::Entity; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Entity - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::Entity::is_absolute"}) {
        $mock = mock 'Path::Class::Entity' => (
            override => [
                is_absolute => sub {
                    my $self = shift;
                    return $self->{is_absolute};
                }
            ]
        );
    } else {
        $mock = mock 'Path::Class::Entity' => (
            add => [
                is_absolute => sub {
                    my $self = shift;
                    return $self->{is_absolute};
                }
            ]
        );
    }
}

# Test case: Path is relative
{
    my $entity = bless { is_absolute => 0 }, 'Path::Class::Entity';
    my $result = eval { Path::Class::Entity::is_relative($entity) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 1, 'is_relative returns true for a relative path');
    }
}

# Test case: Path is absolute
{
    my $entity = bless { is_absolute => 1 }, 'Path::Class::Entity';
    my $result = eval { Path::Class::Entity::is_relative($entity) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 0, 'is_relative returns false for an absolute path');
    }
}

# Test case: is_absolute returns an unexpected value (e.g., undef)
{
    my $entity = bless { is_absolute => undef }, 'Path::Class::Entity';
    my $result = eval { Path::Class::Entity::is_relative($entity) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 1, 'is_relative returns true when is_absolute returns undef');
    }
}

# Test case: is_absolute returns a non-boolean value (e.g., string)
{
    my $entity = bless { is_absolute => 'some_string' }, 'Path::Class::Entity';
    my $result = eval { Path::Class::Entity::is_relative($entity) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 0, 'is_relative returns false when is_absolute returns a non-boolean value');
    }
}

done_testing();