use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Entity; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Entity::new_foreign"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'new_foreign is defined'); }

# Mocking dependencies
mock 'Path::Class::Entity' => (
    override => [
        _spec_class => sub { return 'Mock::SpecClass' },
        new        => sub { return bless {}, 'Path::Class::Entity' },
    ],
);

# Test case: Valid input
my $result = eval { Path::Class::Entity->new_foreign('Unix') };
if ($@) {
    fail('Function crashed with valid input: ' . $@);
} else {
    ok(defined $result, 'Function returns result with valid input');
    isa_ok($result, 'Path::Class::Entity', 'Result is a Path::Class::Entity object');
}

# Test case: Invalid input (empty type)
$result = eval { Path::Class::Entity->new_foreign('') };
if ($@) {
    like($@, qr/Invalid file system type/, 'Function dies with invalid input (empty type)');
} else {
    fail('Function did not die with invalid input (empty type)');
}

# Test case: Invalid input (invalid type)
$result = eval { Path::Class::Entity->new_foreign('InvalidType') };
if ($@) {
    like($@, qr/Invalid file system type/, 'Function dies with invalid input (invalid type)');
} else {
    fail('Function did not die with invalid input (invalid type)');
}

# Test case: Additional arguments
$result = eval { Path::Class::Entity->new_foreign('Unix', 'arg1', 'arg2') };
if ($@) {
    fail('Function crashed with additional arguments: ' . $@);
} else {
    ok(defined $result, 'Function returns result with additional arguments');
    isa_ok($result, 'Path::Class::Entity', 'Result is a Path::Class::Entity object');
}

# Clean up mocks
unmock 'Path::Class::Entity';

done_testing();
