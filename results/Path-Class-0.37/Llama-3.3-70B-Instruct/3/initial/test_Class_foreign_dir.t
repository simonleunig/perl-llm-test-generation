use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock;
use File::Temp qw/tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::foreign_dir"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'foreign_dir is defined'); }

# Test case 1: Valid directory path
my $result = eval { Path::Class::foreign_dir('path', 'to', 'directory') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for valid directory path'); }

# Test case 2: Invalid directory path
$result = eval { Path::Class::foreign_dir(undef) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result, 'Function returns undef for invalid directory path'); }

# Test case 3: Empty directory path
$result = eval { Path::Class::foreign_dir() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result, 'Function returns undef for empty directory path'); }

# Test case 4: Directory path with volume specification
my $temp_dir = tempdir();
$result = eval { Path::Class::foreign_dir($temp_dir) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for directory path with volume specification'); }

done_testing();
