use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Entity; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Entity::_spec"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, '_spec is defined'); }

my $obj_with_file_spec_class = bless { file_spec_class => 'File::Spec' }, 'Path::Class::Entity';
my $result = eval { Path::Class::Entity::_spec($obj_with_file_spec_class) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'File::Spec', '_spec returns file_spec_class attribute'); }

my $obj_without_file_spec_class = bless {}, 'Path::Class::Entity';
$result = eval { Path::Class::Entity::_spec($obj_without_file_spec_class) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'File::Spec', '_spec returns default File::Spec'); }

$result = eval { Path::Class::Entity::_spec('non-object reference') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'File::Spec', '_spec returns default File::Spec for non-object reference'); }

$result = eval { Path::Class::Entity::_spec(undef) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'File::Spec', '_spec returns default File::Spec for undefined input'); }

done_testing();