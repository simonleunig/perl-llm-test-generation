use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::dir_list"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'dir_list is defined'); }

# Create a new Path::Class::Dir object
my $dir = Path::Class::Dir->new('path', 'to', 'directory');

# Test case 1: No offset or length provided
my $result = eval { $dir->dir_list() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }
is(ref $result, 'ARRAY', 'Returns an array reference');

# Test case 2: Offset provided
$result = eval { $dir->dir_list(1) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }
is(ref $result, 'ARRAY', 'Returns an array reference');

# Test case 3: Offset and length provided
$result = eval { $dir->dir_list(1, 2) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }
is(ref $result, 'ARRAY', 'Returns an array reference');

# Test case 4: Negative offset
$result = eval { $dir->dir_list(-1) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }
is(ref $result, 'ARRAY', 'Returns an array reference');

# Test case 5: Negative length
$result = eval { $dir->dir_list(1, -2) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }
is(ref $result, 'ARRAY', 'Returns an array reference');

# Test case 6: Scalar context
my $scalar_result = eval { scalar $dir->dir_list(1) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $scalar_result, 'Function returns result in scalar context'); }
is(ref $scalar_result, '', 'Returns a scalar value');

done_testing();
