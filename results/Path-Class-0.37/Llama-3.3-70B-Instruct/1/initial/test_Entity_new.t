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

# Test case 1: Valid object reference
my $entity = bless {}, 'Path::Class::Entity';
$entity->{file_spec_class} = 'File::Spec';
my $result = eval { Path::Class::Entity->new($entity) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result with valid object reference'); }

# Test case 2: Valid string
my $result2 = eval { Path::Class::Entity->new('Path::Class::Entity') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result2, 'Function returns result with valid string'); }

# Test case 3: Invalid input
my $result3 = eval { Path::Class::Entity->new(123) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result3, 'Function returns result with invalid input'); }

# Test case 4: Edge case - undefined input
my $result4 = eval { Path::Class::Entity->new() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result4, 'Function returns result with undefined input'); }

done_testing();
