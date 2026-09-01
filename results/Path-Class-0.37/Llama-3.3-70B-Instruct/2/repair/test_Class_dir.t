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

# Test case: Create a new Path::Class::Dir object
my $result = eval { Path::Class::dir('foo', 'bar') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }

# Test case: Check if the returned object is an instance of Path::Class::Dir
$result = eval { Path::Class::dir('foo', 'bar') };
if ($@) { fail('Function crashed: ' . $@); } else { ok($result->isa('Path::Class::Dir'), 'Returned object is an instance of Path::Class::Dir'); }

# Test case: Check if the dir function handles empty input
$result = eval { Path::Class::dir() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result with empty input'); }

# Test case: Check if the dir function handles invalid directory components
$result = eval { Path::Class::dir('foo', undef, 'bar') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result with invalid directory components'); }

done_testing();
