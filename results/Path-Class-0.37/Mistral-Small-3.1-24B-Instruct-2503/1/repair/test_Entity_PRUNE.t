use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Entity; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Entity::PRUNE"} };
if ($@) {
    fail('Symbol check crashed: ' . $@);
} else {
    ok($symbol_check, 'PRUNE is defined');
}

# Test case: PRUNE returns a reference to itself
my $result = eval { Path::Class::Entity::PRUNE() };
if ($@) {
    fail('Function crashed: ' . $@);
} else {
    ok(defined $result, 'PRUNE returns a result');
    is(ref($result), 'CODE', 'PRUNE returns a reference to itself');
    is($result, \&Path::Class::Entity::PRUNE, 'PRUNE returns a reference to the PRUNE function');
}

# Additional test case: Ensure PRUNE can be used in a file traversal context
# Mocking File::Find for demonstration purposes
my $mock;
eval { require File::Find; };
if ($@) {
    # DEPENDENCY MISSING: File::Find - mock skipped
} else {
    no strict 'refs';
    if (defined &{"File::Find::find"}) {
        $mock = mock 'File::Find', find => sub {
            my ($wanted, $dir) = @_;
            $wanted->($dir);
        };
    } else {
        $mock = mock 'File::Find', add => {
            find => sub {
                my ($wanted, $dir) = @_;
                $wanted->($dir);
            }
        };
    }
}

# Simulate a file traversal scenario
my $mock_wanted = sub {
    my $dir = shift;
    if ($dir eq 'skip_me') {
        Path::Class::Entity::PRUNE();
    }
};

# Call the mocked find function
eval { File::Find::find($mock_wanted, 'skip_me') };
if ($@) {
    fail('Mocked file traversal crashed: ' . $@);
} else {
    pass('Mocked file traversal completed without errors');
}

done_testing();