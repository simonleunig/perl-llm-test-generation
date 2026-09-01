use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Entity; }  # Use actual module name from package declaration

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Entity::_spec"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, '_spec is defined'); }

# Test case: Object with file_spec_class attribute
{
    my $object = bless { file_spec_class => 'Custom::Spec' }, 'Path::Class::Entity';
    my $result = eval { Path::Class::Entity::_spec($object) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 'Custom::Spec', 'Returns file_spec_class when attribute is set');
    }
}

# Test case: Object without file_spec_class attribute
{
    my $object = bless {}, 'Path::Class::Entity';
    my $result = eval { Path::Class::Entity::_spec($object) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 'File::Spec', 'Returns File::Spec when attribute is not set');
    }
}

# Test case: Non-object input
{
    my $result = eval { Path::Class::Entity::_spec('not an object') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 'File::Spec', 'Returns File::Spec for non-object input');
    }
}

# Test case: Undefined input
{
    my $result = eval { Path::Class::Entity::_spec(undef) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 'File::Spec', 'Returns File::Spec for undefined input');
    }
}

# Test case: Input that is not a reference
{
    my $result = eval { Path::Class::Entity::_spec('string') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 'File::Spec', 'Returns File::Spec for non-reference input');
    }
}

done_testing();
