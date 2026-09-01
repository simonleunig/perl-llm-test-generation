use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw(mock unmock);
use File::Temp qw(tempfile tempdir);
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::volume"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'volume is defined'); }

# Mocking Path::Class::Dir
my $mock;
eval { require Path::Class::Dir; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Dir - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::Dir::volume"}) {
        $mock = mock 'Path::Class::Dir' => (
            override => [
                volume => sub {
                    my $self = shift;
                    return 'C:';  # Mocked volume
                }
            ]
        );
    } else {
        $mock = mock 'Path::Class::Dir' => (
            add => [
                volume => sub {
                    my $self = shift;
                    return 'C:';  # Mocked volume
                }
            ]
        );
    }
}

# Test case: File object with directory component
{
    my $file = bless { dir => Path::Class::Dir->new('C:/path/to/file') }, 'Path::Class::File';
    my $result = eval { $file->volume() };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 'C:', 'volume returns correct volume for file with directory component');
    }
}

# Test case: File object without directory component
{
    my $file = bless { dir => undef }, 'Path::Class::File';
    my $result = eval { $file->volume() };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, '', 'volume returns empty string for file without directory component');
    }
}

# Test case: File object with undefined directory component
{
    my $file = bless {}, 'Path::Class::File';
    my $result = eval { $file->volume() };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, '', 'volume returns empty string for file with undefined directory component');
    }
}

# Clean up mocks
unmock 'Path::Class::Dir';

done_testing();