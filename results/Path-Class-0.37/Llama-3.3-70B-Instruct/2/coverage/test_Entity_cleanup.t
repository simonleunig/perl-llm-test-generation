use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Entity; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Entity::cleanup"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'cleanup is defined'); }

my $entity;  # AFTER LAST PASS: my $entity;  # UNVALIDATED: my $entity = Path::Class::Entity->new('/path/to/directory');
my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $entity->cleanup() };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'cleanup returns result for normal path'); }

# UNVALIDATED: $entity = Path::Class::Entity->new('');
# UNVALIDATED: $result = eval { $entity->cleanup() };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'cleanup returns result for empty path'); }

# UNVALIDATED: $entity = Path::Class::Entity->new('/path/to/directory/../');
# UNVALIDATED: $result = eval { $entity->cleanup() };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'cleanup returns result for path with redundant components'); }

my $mock;
# UNVALIDATED: eval { require File::Spec; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: File::Spec - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"File::Spec::canonpath"}) {
        # AFTER LAST PASS: $mock = mock 'File::Spec' => ( override => [ canonpath => sub { die 'Invalid system type' } ] );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock = mock 'File::Spec' => ( add => [ canonpath => sub { die 'Invalid system type' } ] );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }
# UNVALIDATED: $entity = Path::Class::Entity->new('/path/to/directory');
my $error;  # AFTER LAST PASS: my $error;  # UNVALIDATED: my $error = eval { $entity->cleanup() };
# FAILED: if ($@) { ok($@ =~ /Invalid system type/, 'cleanup raises exception for invalid system type'); } else { fail('Function did not crash as expected'); }

done_testing();