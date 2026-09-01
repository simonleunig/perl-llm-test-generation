use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Entity; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Entity::new"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'new is defined'); }

my $entity = bless {}, 'Path::Class::Entity';
$entity->{file_spec_class} = 'File::Spec';
my $result = eval { Path::Class::Entity->new($entity) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result with valid object reference'); }

my $result2 = eval { Path::Class::Entity->new('Path::Class::Entity') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result2, 'Function returns result with valid string'); }

my $result3 = eval { Path::Class::Entity->new(123) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result3, 'Function returns no result with invalid input'); }

my $result4 = eval { Path::Class::Entity->new() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result4, 'Function returns no result with undefined input'); }

my $stringify_check = eval { no strict 'refs'; defined &{"Path::Class::Entity::stringify"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($stringify_check, 'stringify is defined'); }

done_testing();