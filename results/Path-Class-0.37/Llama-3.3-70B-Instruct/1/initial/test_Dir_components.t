use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::components"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'components is defined'); }

# Test case: components with no arguments
my $dir = Path::Class::Dir->new(tempdir());
my $result = eval { $dir->components() };
if ($@) { fail('components crashed: ' . $@); } else { ok(defined $result, 'components returns result'); }

# Test case: components with offset and length
$result = eval { $dir->components(1, 2) };
if ($@) { fail('components with offset and length crashed: ' . $@); } else { ok(defined $result, 'components with offset and length returns result'); }

# Test case: components with invalid offset
$result = eval { $dir->components(-1) };
if ($@) { fail('components with invalid offset crashed: ' . $@); } else { ok(defined $result, 'components with invalid offset returns result'); }

# Test case: components with non-numeric offset
$result = eval { $dir->components('a') };
if ($@) { fail('components with non-numeric offset crashed: ' . $@); } else { ok(defined $result, 'components with non-numeric offset returns result'); }

done_testing();
