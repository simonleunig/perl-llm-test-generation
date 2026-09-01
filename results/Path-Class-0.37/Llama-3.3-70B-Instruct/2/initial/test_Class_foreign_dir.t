use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::foreign_dir"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'foreign_dir is defined'); }

# Test case 1: Valid foreign directory path
my $result = eval { Path::Class::foreign_dir('path', 'to', 'directory') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for valid foreign directory path'); }

# Test case 2: Invalid foreign directory path
$result = eval { Path::Class::foreign_dir(undef) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for invalid foreign directory path'); }

# Test case 3: Empty foreign directory path
$result = eval { Path::Class::foreign_dir() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for empty foreign directory path'); }

# Test case 4: Malformed foreign directory path
$result = eval { Path::Class::foreign_dir('path|to|directory') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for malformed foreign directory path'); }

done_testing();
