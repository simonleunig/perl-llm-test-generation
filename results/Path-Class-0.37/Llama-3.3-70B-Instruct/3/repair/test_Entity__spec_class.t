use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Entity; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Entity::_spec_class"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, '_spec_class is defined'); }

# Test case with valid system type
my $result = eval { Path::Class::Entity::_spec_class('Path::Class::Entity', 'Unix') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'File::Spec::Unix', 'Returns correct class for Unix'); }

# Test case with invalid system type
my $invalid_result = eval { Path::Class::Entity::_spec_class('Path::Class::Entity', '!@#$') };
if ($@) { like($@, qr/Invalid system type/, 'Dies with correct error message for invalid system type'); } else { fail('Expected function to die for invalid system type'); }

# Test case with empty system type
my $empty_result = eval { Path::Class::Entity::_spec_class('Path::Class::Entity', '') };
if ($@) { like($@, qr/Invalid system type/, 'Dies with correct error message for empty system type'); } else { fail('Expected function to die for empty system type'); }

done_testing();
