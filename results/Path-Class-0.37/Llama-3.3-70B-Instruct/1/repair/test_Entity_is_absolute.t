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

my $entity = bless({}, 'Path::Class::Entity');

my $mock_spec;
eval { require File::Spec; };
if ($@) {
    # DEPENDENCY MISSING: File::Spec - mock skipped
} else {
    no strict 'refs';
    if (defined &{"File::Spec::file_name_is_absolute"}) {
        $mock_spec = mock 'File::Spec' => (override => [file_name_is_absolute => sub { return 1 }]);
    } else {
        $mock_spec = mock 'File::Spec' => (add => [file_name_is_absolute => sub { return 1 }]);
    }
}

my $mock_stringify = mock $entity => (
    stringify => sub { return '/absolute/path' },
    _spec => sub { return $mock_spec },
);

my $result = eval { $entity->is_absolute };
if ($@) { fail('is_absolute crashed: ' . $@); } else { ok($result, 'is_absolute returns true for absolute path'); }

$mock_spec = mock 'File::Spec' => (override => [file_name_is_absolute => sub { return 0 }]);
$mock_stringify = mock $entity => (
    stringify => sub { return 'relative/path' },
    _spec => sub { return $mock_spec },
);

$result = eval { $entity->is_absolute };
if ($@) { fail('is_absolute crashed: ' . $@); } else { ok(!$result, 'is_absolute returns false for relative path'); }

$mock_spec = mock 'File::Spec' => (override => [file_name_is_absolute => sub { die 'Error in file_name_is_absolute' }]);
$mock_stringify = mock $entity => (
    stringify => sub { return '/absolute/path' },
    _spec => sub { return $mock_spec },
);

my $error = eval { $entity->is_absolute };
if ($@) { ok(1, 'is_absolute propagates error correctly'); like($@, qr/Error in file_name_is_absolute/, 'Error message correct'); } else { fail('is_absolute did not propagate error'); }

done_testing();