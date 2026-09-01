use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Entity; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Entity::new"} };
if ($@) { fail("Symbol check crashed: $@"); } else { ok($symbol_check, "new is defined"); }

my $entity = eval { Path::Class::Entity->new({ file_spec_class => 'File::Spec' }) };
if ($@) { fail("Function crashed: $@"); } else { ok(defined $entity, "Create instance with object reference"); }

$entity = eval { Path::Class::Entity->new('Path::Class::Entity') };
if ($@) { fail("Function crashed: $@"); } else { ok(defined $entity, "Create instance with string"); }

$entity = eval { Path::Class::Entity->new(123) };
if ($@) { fail("Function crashed: $@"); } else { ok(!defined $entity, "Create instance with invalid input"); }

my $file_spec_class = eval { $entity->{file_spec_class} };
if ($@) { fail("Function crashed: $@"); } else { is($file_spec_class, 'Path::Class::Foreign', "Check file_spec_class attribute"); }

my $error = eval { Path::Class::Entity->new(123) };
ok($@, "Dies with bad input");
like($@, qr/Can't locate object method/, "Error message correct");

done_testing();