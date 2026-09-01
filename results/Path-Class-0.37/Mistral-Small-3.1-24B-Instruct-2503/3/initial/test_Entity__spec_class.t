use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Entity; }  # Use actual module name from package declaration

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Entity::_spec_class"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, '_spec_class is defined'); }

# Test case: Valid system type
{
    my $result = eval { Path::Class::Entity::_spec_class('Path::Class::Entity', 'Unix') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 'File::Spec::Unix', 'Returns correct File::Spec module for Unix');
    }
}

# Test case: Valid system type (Win32)
{
    my $result = eval { Path::Class::Entity::_spec_class('Path::Class::Entity', 'Win32') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 'File::Spec::Win32', 'Returns correct File::Spec module for Win32');
    }
}

# Test case: Invalid system type (empty string)
{
    my $result = eval { Path::Class::Entity::_spec_class('Path::Class::Entity', '') };
    if ($@) {
        like($@, qr/Invalid system type ''/, 'Dies with correct message for empty system type');
    } else {
        fail('Function did not die for empty system type');
    }
}

# Test case: Invalid system type (contains invalid characters)
{
    my $result = eval { Path::Class::Entity::_spec_class('Path::Class::Entity', 'Unix!@#') };
    if ($@) {
        like($@, qr/Invalid system type 'Unix!@#'/, 'Dies with correct message for invalid system type');
    } else {
        fail('Function did not die for invalid system type');
    }
}

# Test case: Non-existent File::Spec module
{
    mock 'File::Spec::NonExistent', sub { die 'Module not found' };
    my $result = eval { Path::Class::Entity::_spec_class('Path::Class::Entity', 'NonExistent') };
    if ($@) {
        like($@, qr/Module not found/, 'Dies with correct message for non-existent File::Spec module');
    } else {
        fail('Function did not die for non-existent File::Spec module');
    }
}

done_testing();
