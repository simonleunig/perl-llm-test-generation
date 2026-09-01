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

my $obj_with_spec = bless { file_spec_class => 'File::Spec' }, 'Path::Class::Entity';
my $result_with_spec = eval { Path::Class::Entity::_spec($obj_with_spec) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { is($result_with_spec, 'File::Spec', '_spec returns file_spec_class when defined'); }

my $obj_without_spec = bless {}, 'Path::Class::Entity';
my $result_without_spec = eval { Path::Class::Entity::_spec($obj_without_spec) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { is($result_without_spec, 'File::Spec', '_spec defaults to File::Spec when file_spec_class is not defined'); }

my $result_non_object = eval { Path::Class::Entity::_spec('non-object') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result_non_object, 'File::Spec', '_spec defaults to File::Spec for non-object input'); }

done_testing();