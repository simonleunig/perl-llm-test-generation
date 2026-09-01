use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::children"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'children is defined'); }

# Create a temporary directory
my $temp_dir = tempdir(CLEANUP => 1);

# Create a Path::Class::Dir object
my $dir = Path::Class::Dir->new($temp_dir);

# Test case 1: Test with no options
my $result = eval { $dir->children() };
if ($@) { fail('children() crashed: ' . $@); } else { ok(defined $result, 'children() returns result'); }

# Test case 2: Test with 'all' option
my $result_all = eval { $dir->children(all => 1) };
if ($@) { fail('children(all => 1) crashed: ' . $@); } else { ok(defined $result_all, 'children(all => 1) returns result'); }

# Test case 3: Test with 'no_hidden' option
my $result_no_hidden = eval { $dir->children(no_hidden => 1) };
if ($@) { fail('children(no_hidden => 1) crashed: ' . $@); } else { ok(defined $result_no_hidden, 'children(no_hidden => 1) returns result'); }

# Test case 4: Test with both 'all' and 'no_hidden' options
my $result_all_no_hidden = eval { $dir->children(all => 1, no_hidden => 1) };
if ($@) { fail('children(all => 1, no_hidden => 1) crashed: ' . $@); } else { ok(defined $result_all_no_hidden, 'children(all => 1, no_hidden => 1) returns result'); }

# Test case 5: Test error handling
my $invalid_dir = Path::Class::Dir->new('/non/existent/directory');
my $result_invalid_dir = eval { $invalid_dir->children() };
if ($@) { ok($@ =~ /Can't open directory/, 'children() throws error for invalid directory'); } else { fail('children() did not throw error for invalid directory'); }

done_testing();
