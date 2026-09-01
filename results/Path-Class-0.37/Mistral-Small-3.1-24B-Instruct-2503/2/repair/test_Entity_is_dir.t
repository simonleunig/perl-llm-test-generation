use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Entity; }  # Use actual module name from package declaration

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Entity::is_dir"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'is_dir is defined'); }

# Test case: is_dir always returns 0
{
    my $entity = bless {}, 'Path::Class::Entity';
    my $result = eval { $entity->is_dir() };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 0, 'is_dir returns 0');
    }
}

# Test case: is_dir does not take any arguments
{
    my $entity = bless {}, 'Path::Class::Entity';
    my $result = eval { $entity->is_dir(1) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 0, 'is_dir returns 0 even with arguments');
    }
}

# Test case: is_dir does not perform any operations that could fail
{
    my $entity = bless {}, 'Path::Class::Entity';
    my $result = eval { $entity->is_dir() };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 0, 'is_dir does not perform operations that could fail');
    }
}

done_testing();
