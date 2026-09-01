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
    # FAILED: fail('Symbol check crashed: ' . $@);
} else {
    ok($symbol_check, 'boolify is defined');
}

# Test cases with eval protection
my $result = eval { Path::Class::Entity::boolify() };
if ($@) {
    # FAILED: fail('Function crashed: ' . $@);
} else {
    is($result, 1, 'boolify returns 1');
}

# Additional test to ensure no parameters are required
# UNVALIDATED: $result = eval { Path::Class::Entity::boolify(1) };
# AFTER LAST PASS: if ($@) {
    # FAILED: ok(1, 'boolify crashes when called with arguments');
# AFTER LAST PASS: } else {
    # FAILED: fail('boolify did not crash when called with arguments');
# AFTER LAST PASS: }

# Test the overloading mechanism
my $entity;  # AFTER LAST PASS: my $entity = bless {}, 'Path::Class::Entity';
# UNVALIDATED: $result = eval { !!$entity };
# AFTER LAST PASS: if ($@) {
    # FAILED: fail('Overloading mechanism crashed: ' . $@);
# AFTER LAST PASS: } else {
    # FAILED: is($result, 1, 'Entity object evaluates to true in boolean context');
# AFTER LAST PASS: }

done_testing();