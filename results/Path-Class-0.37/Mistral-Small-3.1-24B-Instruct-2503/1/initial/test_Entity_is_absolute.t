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

# Mocking File::Spec
mock 'File::Spec' => (
    override => [
        file_name_is_absolute => sub {
            my ($class, $path) = @_;
            return $path =~ m{^/} ? 1 : 0;  # Simplified mock for Unix-like paths
        },
    ],
);

# Test cases with eval protection
my $entity = bless {}, 'Path::Class::Entity';

# Test with an absolute path
my $result = eval { $entity->is_absolute('/absolute/path') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 1, 'Absolute path is detected correctly'); }

# Test with a relative path
$result = eval { $entity->is_absolute('relative/path') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 0, 'Relative path is detected correctly'); }

# Test with an empty path
$result = eval { $entity->is_absolute('') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 0, 'Empty path is detected correctly'); }

# Test with a path containing only whitespace
$result = eval { $entity->is_absolute('   ') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 0, 'Whitespace-only path is detected correctly'); }

# Test with a path that starts with a drive letter (Windows-like)
$result = eval { $entity->is_absolute('C:relative/path') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 0, 'Drive-letter relative path is detected correctly'); }

# Test with a path that is an absolute drive letter path (Windows-like)
mock 'File::Spec' => (
    override => [
        file_name_is_absolute => sub {
            my ($class, $path) = @_;
            return $path =~ m{^[A-Za-z]:\\} ? 1 : 0;  # Simplified mock for Windows-like paths
        },
    ],
);
$result = eval { $entity->is_absolute('C:\\absolute\\path') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 1, 'Absolute drive-letter path is detected correctly'); }

done_testing();
