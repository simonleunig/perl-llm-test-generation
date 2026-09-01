use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Entity; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Entity::new"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'new is defined'); }

# Test case 1: Create a new instance with an object reference
my $entity = eval { Path::Class::Entity->new({ file_spec_class => 'File::Spec' }) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $entity, 'Create instance with object reference'); }

# Test case 2: Create a new instance with a string
$entity = eval { Path::Class::Entity->new('Path::Class::Entity') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $entity, 'Create instance with string'); }

# Test case 3: Create a new instance with an invalid input
$entity = eval { Path::Class::Entity->new(123) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $entity, 'Create instance with invalid input'); }

# Test case 4: Check the file_spec_class attribute
my $file_spec_class = eval { $entity->{file_spec_class} };
if ($@) { fail('Function crashed: ' . $@); } else { is($file_spec_class, 'File::Spec', 'Check file_spec_class attribute'); }

done_testing();
