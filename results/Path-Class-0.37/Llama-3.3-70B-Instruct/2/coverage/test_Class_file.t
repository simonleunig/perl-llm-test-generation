use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::file"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'file is defined'); }

# Test case: Successful creation of a Path::Class::File object
my $result = eval { Path::Class::file('test', 'file.txt') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }

# Test case: Invalid input (non-existent file)
$result = eval { Path::Class::file('non_existent', 'file.txt') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for non-existent file'); }

# Test case: Invalid input (empty path components)
$result = eval { Path::Class::file('', '') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for empty path components'); }

# Test case: Edge case (single path component)
$result = eval { Path::Class::file('single_component') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for single path component'); }

done_testing();
