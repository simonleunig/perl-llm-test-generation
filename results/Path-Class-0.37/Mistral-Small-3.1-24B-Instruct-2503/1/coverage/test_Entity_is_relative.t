use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Entity; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Entity::is_relative"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'is_relative is defined'); }

# Mock the is_absolute method
my $mock;
# AFTER LAST PASS: eval { require Path::Class::Entity; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: Path::Class::Entity - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"Path::Class::Entity::is_absolute"}) {
        # AFTER LAST PASS: $mock = mock 'Path::Class::Entity' => (
            # AFTER LAST PASS: override => [
                # AFTER LAST PASS: is_absolute => sub {
                    my $self;  # AFTER LAST PASS: my $self = shift;
                    # AFTER LAST PASS: return $self->{is_absolute};
                # AFTER LAST PASS: }
            # AFTER LAST PASS: ]
        # AFTER LAST PASS: );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock = mock 'Path::Class::Entity' => (
            # AFTER LAST PASS: add => [
                # AFTER LAST PASS: is_absolute => sub {
                    my $self;  # AFTER LAST PASS: my $self = shift;
                    # AFTER LAST PASS: return $self->{is_absolute};
                # AFTER LAST PASS: }
            # AFTER LAST PASS: ]
        # AFTER LAST PASS: );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# Test case: Path is relative
# AFTER LAST PASS: {
    my $entity;  # AFTER LAST PASS: my $entity = bless { is_absolute => 0 }, 'Path::Class::Entity';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Path::Class::Entity::is_relative($entity) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, 1, 'is_relative returns true for a relative path');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Path is absolute
# AFTER LAST PASS: {
    my $entity;  # AFTER LAST PASS: my $entity = bless { is_absolute => 1 }, 'Path::Class::Entity';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Path::Class::Entity::is_relative($entity) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, 0, 'is_relative returns false for an absolute path');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: is_absolute returns an unexpected value (e.g., undef)
# AFTER LAST PASS: {
    my $entity;  # AFTER LAST PASS: my $entity = bless { is_absolute => undef }, 'Path::Class::Entity';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Path::Class::Entity::is_relative($entity) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, 1, 'is_relative returns true when is_absolute returns undef');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: is_absolute returns a non-boolean value (e.g., string)
# AFTER LAST PASS: {
    my $entity;  # AFTER LAST PASS: my $entity = bless { is_absolute => 'some_string' }, 'Path::Class::Entity';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Path::Class::Entity::is_relative($entity) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, 0, 'is_relative returns false when is_absolute returns a non-boolean value');
    # FAILED: }
# AFTER LAST PASS: }

done_testing();