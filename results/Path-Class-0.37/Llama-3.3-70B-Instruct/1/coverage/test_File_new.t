use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::new"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'new is defined'); }

# Test case 1: Create a new Path::Class::File object with a file name
my $result = eval { Path::Class::File->new('test.txt') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }

# Test case 2: Create a new Path::Class::File object with directory components and a file name
$result = eval { Path::Class::File->new('dir1', 'dir2', 'test.txt') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }

# Test case 3: Create a new Path::Class::File object with an absolute file path
$result = eval { Path::Class::File->new('/absolute/path/test.txt') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }

# Test case 4: Create a new Path::Class::File object with an empty file name
$result = eval { Path::Class::File->new('') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }

# Test case 5: Create a new Path::Class::File object with no arguments
$result = eval { Path::Class::File->new() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }

done_testing();
