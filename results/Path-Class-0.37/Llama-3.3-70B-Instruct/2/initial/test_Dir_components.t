use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::components"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'components is defined'); }

# Test case: components with no arguments
my $dir = Path::Class::Dir->new('path/to/directory');
my $result = eval { $dir->components() };
if ($@) { fail('components crashed: ' . $@); } else { ok(defined $result, 'components returns result'); }

# Test case: components with offset and length
$result = eval { $dir->components(1, 2) };
if ($@) { fail('components crashed: ' . $@); } else { ok(defined $result, 'components returns result with offset and length'); }

# Test case: components with invalid offset
$result = eval { $dir->components(-1, 2) };
if ($@) { fail('components crashed: ' . $@); } else { ok(defined $result, 'components returns result with invalid offset'); }

# Test case: components with invalid length
$result = eval { $dir->components(1, -2) };
if ($@) { fail('components crashed: ' . $@); } else { ok(defined $result, 'components returns result with invalid length'); }

# Test case: components with non-numeric offset
$result = eval { $dir->components('a', 2) };
if ($@) { fail('components crashed: ' . $@); } else { ok(defined $result, 'components returns result with non-numeric offset'); }

# Test case: components with non-numeric length
$result = eval { $dir->components(1, 'b') };
if ($@) { fail('components crashed: ' . $@); } else { ok(defined $result, 'components returns result with non-numeric length'); }

done_testing();
