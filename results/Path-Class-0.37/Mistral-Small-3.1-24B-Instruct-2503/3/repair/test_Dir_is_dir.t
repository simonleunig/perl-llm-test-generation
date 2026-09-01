use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw(tempfile tempdir);
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::is_dir"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'is_dir is defined'); }

# Test cases with eval protection
my $dir = Path::Class::Dir->new('some/directory');

# Test that is_dir returns 1 for a Path::Class::Dir object
my $result = eval { $dir->is_dir() };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, 1, 'is_dir returns 1 for a Path::Class::Dir object');
}

# Additional test to ensure no arguments are required
$result = eval { $dir->is_dir('unexpected_argument') };
if ($@) { pass('Function correctly fails with unexpected argument'); } else {
    fail('Function did not fail with unexpected argument');
}

# Clean up any temporary files or directories if necessary
# (In this case, no temporary files/directories were created)

done_testing();