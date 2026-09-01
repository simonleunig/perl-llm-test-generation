use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Entity; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Entity::boolify"} };
if ($@) {
    fail('Symbol check crashed: ' . $@);
} else {
    ok($symbol_check, 'boolify is defined');
}

# Test cases with eval protection
my $result = eval { Path::Class::Entity::boolify() };
if ($@) {
    fail('Function crashed: ' . $@);
} else {
    is($result, 1, 'boolify returns 1');
}

# Additional test to ensure no parameters are required
$result = eval { Path::Class::Entity::boolify(1) };
if ($@) {
    ok(1, 'boolify crashes when called with arguments');
} else {
    fail('boolify did not crash when called with arguments');
}

# Test the overloading mechanism
my $entity = bless {}, 'Path::Class::Entity';
$result = eval { !!$entity };
if ($@) {
    fail('Overloading mechanism crashed: ' . $@);
} else {
    is($result, 1, 'Entity object evaluates to true in boolean context');
}

done_testing();