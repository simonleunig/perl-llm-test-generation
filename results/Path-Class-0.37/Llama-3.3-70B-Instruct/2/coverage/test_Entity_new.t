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

# Test case 1: Object reference as input
my $object_ref = bless { file_spec_class => 'File::Spec' }, 'Path::Class::Entity';
my $result1 = eval { Path::Class::Entity->new($object_ref) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result1, 'Function returns result with object reference'); }

# Test case 2: String as input
my $string_input = 'Path::Class::Foreign';
my $result2 = eval { Path::Class::Entity->new($string_input) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result2, 'Function returns result with string input'); }

# Test case 3: Invalid input (undefined)
my $invalid_input;
my $result3 = eval { Path::Class::Entity->new($invalid_input) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result3, 'Function returns result with invalid input'); }

# Test case 4: Edge case - empty string as input
my $empty_string = '';
my $result4 = eval { Path::Class::Entity->new($empty_string) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result4, 'Function returns result with empty string input'); }

done_testing();
