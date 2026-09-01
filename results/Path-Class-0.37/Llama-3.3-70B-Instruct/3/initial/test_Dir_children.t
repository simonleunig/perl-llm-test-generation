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
my $temp_dir = tempdir();
my $dir = Path::Class::Dir->new($temp_dir);

# Test case 1: Successful call with no options
my $result = eval { $dir->children() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }

# Test case 2: Successful call with all option
my $result_all = eval { $dir->children(all => 1) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result_all, 'Function returns result with all option'); }

# Test case 3: Successful call with no_hidden option
my $result_no_hidden = eval { $dir->children(no_hidden => 1) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result_no_hidden, 'Function returns result with no_hidden option'); }

# Test case 4: Error handling - directory cannot be opened
my $mock_dir = mock 'Path::Class::Dir' => (open => sub { return undef });
my $result_error = eval { $mock_dir->children() };
if ($@) { like($@, qr/Can't open directory/, 'Function throws correct error'); } else { fail('Function did not throw error'); }

# Clean up resources
END { rmdir $temp_dir; }

done_testing();
