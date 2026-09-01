use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Entity; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Entity::is_absolute"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'is_absolute is defined'); }

# Test case 1: Absolute path
my $entity = bless({}, 'Path::Class::Entity');
my $mock_spec = mock 'File::Spec' => (
    file_name_is_absolute => sub { return 1 },
);
my $mock_stringify = mock $entity => (
    stringify => sub { return '/absolute/path' },
    _spec => sub { return $mock_spec },
);
my $result = eval { $entity->is_absolute };
if ($@) { fail('is_absolute crashed: ' . $@); } else { ok($result, 'is_absolute returns true for absolute path'); }

# Test case 2: Relative path
$mock_spec = mock 'File::Spec' => (
    file_name_is_absolute => sub { return 0 },
);
$mock_stringify = mock $entity => (
    stringify => sub { return 'relative/path' },
    _spec => sub { return $mock_spec },
);
$result = eval { $entity->is_absolute };
if ($@) { fail('is_absolute crashed: ' . $@); } else { ok(!$result, 'is_absolute returns false for relative path'); }

# Test case 3: Error handling
$mock_spec = mock 'File::Spec' => (
    file_name_is_absolute => sub { die 'Error in file_name_is_absolute' },
);
$mock_stringify = mock $entity => (
    stringify => sub { return '/absolute/path' },
    _spec => sub { return $mock_spec },
);
$result = eval { $entity->is_absolute };
if ($@) { ok(1, 'is_absolute propagates error correctly'); } else { fail('is_absolute did not propagate error'); }

done_testing();
