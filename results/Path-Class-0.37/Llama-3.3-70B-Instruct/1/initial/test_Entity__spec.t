use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Entity; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Entity::_spec"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, '_spec is defined'); }

# Test case: Object with file_spec_class attribute
my $obj_with_file_spec_class = bless { file_spec_class => 'File::Spec' }, 'Path::Class::Entity';
my $result = eval { Path::Class::Entity::_spec($obj_with_file_spec_class) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'File::Spec', '_spec returns file_spec_class attribute'); }

# Test case: Object without file_spec_class attribute
my $obj_without_file_spec_class = bless {}, 'Path::Class::Entity';
$result = eval { Path::Class::Entity::_spec($obj_without_file_spec_class) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'File::Spec', '_spec returns default File::Spec'); }

# Test case: Non-object reference
$result = eval { Path::Class::Entity::_spec('non-object reference') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'File::Spec', '_spec returns default File::Spec for non-object reference'); }

# Test case: Undefined input
$result = eval { Path::Class::Entity::_spec(undef) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'File::Spec', '_spec returns default File::Spec for undefined input'); }

done_testing();
