use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock;
use File::Temp;

# Load the module
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::file_class"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'file_class is defined'); }

# Test cases with eval protection
my $result = eval { Path::Class::Dir::file_class() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }

# Check the return value
is($result, "Path::Class::File", 'file_class returns the correct class name');

done_testing();
