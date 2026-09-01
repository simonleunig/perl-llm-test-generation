use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }  # Use actual module name from package declaration

# Mock dependencies
mock 'Path::Class::Dir' => ( dir => sub { return 'mocked_dir' } );
mock 'Path::Class::Entity' => ();

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::dir"} };
if ($@) {
    fail('Symbol check crashed: ' . $@);
} else {
    ok($symbol_check, 'dir method is defined');
}

# Check if the BEGIN block sets up the alias correctly
my $alias_check = eval { no strict 'refs'; *{"Path::Class::File::parent"} == \&{"Path::Class::File::dir"} };
if ($@) {
    fail('Alias check crashed: ' . $@);
} else {
    ok($alias_check, 'parent is aliased to dir');
}

# Test the dir method
my $file = Path::Class::File->new('test/file.txt');
my $dir_result = eval { $file->dir };
if ($@) {
    fail('dir method crashed: ' . $@);
} else {
    is($dir_result, 'mocked_dir', 'dir method returns the correct directory');
}

# Test the parent method (aliased to dir)
my $parent_result = eval { $file->parent };
if ($@) {
    fail('parent method crashed: ' . $@);
} else {
    is($parent_result, 'mocked_dir', 'parent method returns the correct directory');
}

done_testing();
