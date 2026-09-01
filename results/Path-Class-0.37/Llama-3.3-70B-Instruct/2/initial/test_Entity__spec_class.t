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

# Test case: Valid system type
my $result = eval { Path::Class::Entity::_spec_class('Path::Class::Entity', 'Unix') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for valid system type'); }
is($result, 'File::Spec::Unix', 'Correct File::Spec class returned for Unix');

# Test case: Invalid system type
$result = eval { Path::Class::Entity::_spec_class('Path::Class::Entity', '!@#$') };
if ($@) { like($@, qr/Invalid system type/, 'Correct error message for invalid system type'); } else { fail('Expected function to crash for invalid system type'); }

# Test case: Empty system type
$result = eval { Path::Class::Entity::_spec_class('Path::Class::Entity', '') };
if ($@) { like($@, qr/Invalid system type/, 'Correct error message for empty system type'); } else { fail('Expected function to crash for empty system type'); }

# Test case: Null system type
$result = eval { Path::Class::Entity::_spec_class('Path::Class::Entity', undef) };
if ($@) { like($@, qr/Invalid system type/, 'Correct error message for null system type'); } else { fail('Expected function to crash for null system type'); }

done_testing();
