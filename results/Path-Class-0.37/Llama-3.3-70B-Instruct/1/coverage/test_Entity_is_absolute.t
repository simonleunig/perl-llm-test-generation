use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Entity; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Entity::is_absolute"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'is_absolute is defined'); }

my $entity;  # AFTER LAST PASS: my $entity = bless({}, 'Path::Class::Entity');

my $mock_spec;
# AFTER LAST PASS: eval { require File::Spec; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: File::Spec - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"File::Spec::file_name_is_absolute"}) {
        # AFTER LAST PASS: $mock_spec = mock 'File::Spec' => (override => [file_name_is_absolute => sub { return 1 }]);
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock_spec = mock 'File::Spec' => (add => [file_name_is_absolute => sub { return 1 }]);
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

my $mock_stringify;  # AFTER LAST PASS: my $mock_stringify = mock $entity => (
    # AFTER LAST PASS: stringify => sub { return '/absolute/path' },
    # AFTER LAST PASS: _spec => sub { return $mock_spec },
# AFTER LAST PASS: );

my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $entity->is_absolute };
# FAILED: if ($@) { fail('is_absolute crashed: ' . $@); } else { ok($result, 'is_absolute returns true for absolute path'); }

# AFTER LAST PASS: $mock_spec = mock 'File::Spec' => (override => [file_name_is_absolute => sub { return 0 }]);
# AFTER LAST PASS: $mock_stringify = mock $entity => (
    # AFTER LAST PASS: stringify => sub { return 'relative/path' },
    # AFTER LAST PASS: _spec => sub { return $mock_spec },
# AFTER LAST PASS: );

# UNVALIDATED: $result = eval { $entity->is_absolute };
# FAILED: if ($@) { fail('is_absolute crashed: ' . $@); } else { ok(!$result, 'is_absolute returns false for relative path'); }

# AFTER LAST PASS: $mock_spec = mock 'File::Spec' => (override => [file_name_is_absolute => sub { die 'Error in file_name_is_absolute' }]);
# AFTER LAST PASS: $mock_stringify = mock $entity => (
    # AFTER LAST PASS: stringify => sub { return '/absolute/path' },
    # AFTER LAST PASS: _spec => sub { return $mock_spec },
# AFTER LAST PASS: );

my $error;  # AFTER LAST PASS: my $error;  # UNVALIDATED: my $error = eval { $entity->is_absolute };
# FAILED: if ($@) { ok(1, 'is_absolute propagates error correctly'); like($@, qr/Error in file_name_is_absolute/, 'Error message correct'); } else { fail('is_absolute did not propagate error'); }

done_testing();