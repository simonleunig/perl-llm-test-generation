use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::mkpath"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'mkpath is defined'); }

# Test case: Create a directory
my $temp_dir = tempdir();
my $dir = Path::Class::Dir->new($temp_dir);
my $result = eval { $dir->mkpath() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }

# Test case: Create a nested directory
my $nested_dir = Path::Class::Dir->new($temp_dir, 'nested');
$result = eval { $nested_dir->mkpath() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for nested directory'); }

# Test case: Create a directory with permissions
my $perm_dir = Path::Class::Dir->new($temp_dir, 'perm');
$result = eval { $perm_dir->mkpath(0755) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for directory with permissions'); }

# Test case: Create a directory that already exists
my $existing_dir = Path::Class::Dir->new($temp_dir);
$result = eval { $existing_dir->mkpath() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for existing directory'); }

# Clean up resources
# AFTER LAST PASS: END { rmdir $temp_dir }

done_testing();
