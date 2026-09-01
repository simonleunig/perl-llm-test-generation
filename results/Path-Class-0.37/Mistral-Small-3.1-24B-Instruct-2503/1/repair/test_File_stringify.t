use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::stringify"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'stringify is defined'); }

# Mock dependencies
my $mock_dir;
eval { require Path::Class::Dir; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Dir - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::Dir::dir"}) {
        $mock_dir = mock 'Path::Class::Dir' => ( override => [ dir => sub { return bless { dir => 'mock_dir' }, 'Path::Class::Dir' } ] );
    } else {
        $mock_dir = mock 'Path::Class::Dir' => ( add => [ dir => sub { return bless { dir => 'mock_dir' }, 'Path::Class::Dir' } ] );
    }
}

my $mock_entity;
eval { require Path::Class::Entity; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Entity - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::Entity::_spec"}) {
        $mock_entity = mock 'Path::Class::Entity' => (
            override => [
                _spec => sub {
                    my $self = shift;
                    return bless {
                        catfile => sub {
                            my ($dir, $file) = @_;
                            return File::Spec->catfile($dir, $file);
                        }
                    }, 'Mock::Spec';
                },
            ],
        );
    } else {
        $mock_entity = mock 'Path::Class::Entity' => (
            add => [
                _spec => sub {
                    my $self = shift;
                    return bless {
                        catfile => sub {
                            my ($dir, $file) = @_;
                            return File::Spec->catfile($dir, $file);
                        }
                    }, 'Mock::Spec';
                },
            ],
        );
    }
}

# Test case 1: File with no directory component
{
    my $file = bless { file => 'test_file.txt' }, 'Path::Class::File';
    my $result = eval { $file->stringify() };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 'test_file.txt', 'stringify returns file name when dir is undef');
    }
}

# Test case 2: File with directory component
{
    my $dir = bless { dir => 'mock_dir' }, 'Path::Class::Dir';
    my $file = bless { dir => $dir, file => 'test_file.txt' }, 'Path::Class::File';
    my $result = eval { $file->stringify() };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, File::Spec->catfile('mock_dir', 'test_file.txt'), 'stringify returns full path when dir is defined');
    }
}

# Test case 3: Edge case with empty file name
{
    my $file = bless { file => '' }, 'Path::Class::File';
    my $result = eval { $file->stringify() };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, '', 'stringify returns empty string when file name is empty');
    }
}

# Test case 4: Edge case with empty directory
{
    my $dir = bless { dir => '' }, 'Path::Class::Dir';
    my $file = bless { dir => $dir, file => 'test_file.txt' }, 'Path::Class::File';
    my $result = eval { $file->stringify() };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 'test_file.txt', 'stringify returns file name when dir is empty');
    }
}

done_testing();