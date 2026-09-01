use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }  # Use actual module name from package declaration

# Mock the necessary dependencies
mock 'Path::Class::Dir' => ( dir => sub { return 'mocked_dir' } );
mock 'Path::Class::Entity' => ();

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::dir"} };
if ($@) {
    fail('Symbol check crashed: ' . $@);
} else {
    ok($symbol_check, 'dir method is defined');
}

# Check if the alias is set correctly
my $alias_check = eval { no strict 'refs'; *{"Path::Class::File::parent"} == \&{"Path::Class::File::dir"} };
if ($@) {
    fail('Alias check crashed: ' . $@);
} else {
    ok($alias_check, 'parent method is aliased to dir method');
}

# Test the dir method to ensure it works as expected
my $dir_result = eval { Path::Class::File->dir() };
if ($@) {
    fail('dir method crashed: ' . $@);
} else {
    is($dir_result, 'mocked_dir', 'dir method returns the expected value');
}

# Test the parent method to ensure it works as expected
my $parent_result = eval { Path::Class::File->parent() };
if ($@) {
    fail('parent method crashed: ' . $@);
} else {
    is($parent_result, 'mocked_dir', 'parent method returns the expected value');
}

done_testing();
