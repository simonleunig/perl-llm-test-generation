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

my $obj_with_attr = bless { file_spec_class => 'Custom::Spec' }, 'Path::Class::Entity';
my $result1 = eval { Path::Class::Entity::_spec($obj_with_attr) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result1, 'Custom::Spec', '_spec returns custom class when attribute is present'); }

my $obj_without_attr = bless {}, 'Path::Class::Entity';
my $result2 = eval { Path::Class::Entity::_spec($obj_without_attr) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result2, 'File::Spec', '_spec returns default class when attribute is absent'); }

my $non_obj_input = 'not an object';
my $result3 = eval { Path::Class::Entity::_spec($non_obj_input) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result3, 'File::Spec', '_spec returns default class for non-object input'); }

my $mock;
eval { require File::Spec; };
if ($@) {
    # DEPENDENCY MISSING: File::Spec - mock skipped
} else {
    no strict 'refs';
    if (defined &{"File::Spec::method"}) {
        $mock = mock 'File::Spec' => ( override => [] );
    } else {
        $mock = mock 'File::Spec' => ( add => [] );
    }
}

done_testing();