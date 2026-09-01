use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::dir"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'dir is defined'); }

# Test case: Create a new directory object with valid components
my $result = eval { Path::Class::dir('foo', 'bar') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }

# Test case: Create a new directory object with empty components
$result = eval { Path::Class::dir() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result with empty components'); }

# Test case: Create a new directory object with invalid components (e.g., undef)
$result = eval { Path::Class::dir(undef, 'bar') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result with invalid components'); }

# Test case: Verify the returned object is an instance of Path::Class::Dir
$result = eval { Path::Class::dir('foo', 'bar') };
if ($@) { fail('Function crashed: ' . $@); } else { ok($result->isa('Path::Class::Dir'), 'Returned object is an instance of Path::Class::Dir'); }

done_testing();
