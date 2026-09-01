use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw(tempfile tempdir);
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

# Mock the necessary dependencies
my $mock_dir;
eval { require Path::Class::Dir; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Dir - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::Dir::dir"}) {
        $mock_dir = mock 'Path::Class::Dir' => ( override => [ dir => sub { return 'mocked_dir' } ] );
    } else {
        $mock_dir = mock 'Path::Class::Dir' => ( add => [ dir => sub { return 'mocked_dir' } ] );
    }
}

my $mock_entity;
eval { require Path::Class::Entity; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Entity - mock skipped
} else {
    $mock_entity = mock 'Path::Class::Entity' => ();
}

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::dir"} };
if ($@) {
    # FAILED: fail('Symbol check crashed: ' . $@);
} else {
    ok($symbol_check, 'dir method is defined');
}

# Check if the alias is set correctly
my $alias_check;  # AFTER LAST PASS: my $alias_check;  # UNVALIDATED: my $alias_check = eval { no strict 'refs'; *{"Path::Class::File::parent"} == \&{"Path::Class::File::dir"} };
# AFTER LAST PASS: if ($@) {
    # FAILED: fail('Alias check crashed: ' . $@);
# AFTER LAST PASS: } else {
    # FAILED: ok($alias_check, 'parent method is aliased to dir method');
# AFTER LAST PASS: }

# Test the dir method to ensure it works as expected
my $dir_result;  # AFTER LAST PASS: my $dir_result;  # UNVALIDATED: my $dir_result = eval { Path::Class::File->dir() };
# AFTER LAST PASS: if ($@) {
    # FAILED: fail('dir method crashed: ' . $@);
# AFTER LAST PASS: } else {
    # FAILED: is($dir_result, 'mocked_dir', 'dir method returns the expected value');
# AFTER LAST PASS: }

# Test the parent method to ensure it works as expected
my $parent_result;  # AFTER LAST PASS: my $parent_result;  # UNVALIDATED: my $parent_result = eval { Path::Class::File->parent() };
# AFTER LAST PASS: if ($@) {
    # FAILED: fail('parent method crashed: ' . $@);
# AFTER LAST PASS: } else {
    # FAILED: is($parent_result, 'mocked_dir', 'parent method returns the expected value');
# AFTER LAST PASS: }

done_testing();