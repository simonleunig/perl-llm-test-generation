use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::dir"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'dir is defined'); }

# Test case: Create a new directory object
my $result = eval { Path::Class::dir('foo', 'bar') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'dir returns a result'); }

# Test case: Check the class of the returned object
$result = eval { Path::Class::dir('foo', 'bar') };
if ($@) { fail('Function crashed: ' . $@); } else { ok($result->isa('Path::Class::Dir'), 'dir returns a Path::Class::Dir object'); }

# Test case: Check the path of the returned object
$result = eval { Path::Class::dir('foo', 'bar') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result->dir, File::Spec->catdir('foo', 'bar'), 'dir returns the correct path'); }

# Test case: Edge case - empty input
$result = eval { Path::Class::dir() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'dir returns a result with empty input'); }

# Test case: Edge case - invalid directory components
$result = eval { Path::Class::dir('', 'bar') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'dir returns a result with invalid directory components'); }

done_testing();
