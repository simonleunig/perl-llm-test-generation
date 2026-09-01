use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw(mock unmock);
use File::Temp qw(tempfile tempdir);
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::dir"} };
if ($@) {
    fail('Symbol check crashed: ' . $@);
} else {
    ok($symbol_check, 'dir method is defined');
}

# Mock the dir method to ensure the BEGIN block works correctly
my $mock;
eval { require Path::Class::Dir; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Dir - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::Dir::dir"}) {
        $mock = mock 'Path::Class::Dir' => ( override => { dir => sub { return 'mocked_dir'; } } );
    } else {
        $mock = mock 'Path::Class::Dir' => ( add => { dir => sub { return 'mocked_dir'; } } );
    }
}

# Check if the parent method is correctly aliased to dir
my $parent_method = eval { no strict 'refs'; \&{"Path::Class::File::parent"} };
if ($@) {
    fail('Symbol check for parent method crashed: ' . $@);
} else {
    ok($parent_method, 'parent method is defined');
    is($parent_method, \&{"Path::Class::File::dir"}, 'parent method is aliased to dir');
}

# Test the parent method to ensure it calls the dir method
my $result = eval { Path::Class::File->parent() };
if ($@) {
    fail('Function crashed: ' . $@);
} else {
    ok(defined $result, 'parent method returns a result');
    is($result, 'mocked_dir', 'parent method returns the same result as dir method');
}

# Clean up mocks
unmock 'Path::Class::Dir';

done_testing();