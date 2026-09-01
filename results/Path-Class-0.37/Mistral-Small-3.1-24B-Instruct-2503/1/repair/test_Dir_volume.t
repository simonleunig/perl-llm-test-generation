use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::volume"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'volume is defined'); }

# Mocking Path::Class::Entity to avoid dependencies
my $mock;
eval { require Path::Class::Entity; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Entity - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::Entity::new"}) {
        $mock = mock 'Path::Class::Entity' => (
            override => [
                new => sub {
                    my $class = shift;
                    my $volume = shift;
                    return bless { volume => $volume }, $class;
                }
            ]
        );
    } else {
        $mock = mock 'Path::Class::Entity' => (
            add => [
                new => sub {
                    my $class = shift;
                    my $volume = shift;
                    return bless { volume => $volume }, $class;
                }
            ]
        );
    }
}

# Test case: Directory with a volume
{
    my $dir = eval { Path::Class::Dir->new('C:') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        my $result = eval { $dir->volume() };
        if ($@) { fail('Function crashed: ' . $@); } else {
            is($result, 'C:', 'volume returns correct volume for directory with a volume');
        }
    }
}

# Test case: Directory without a volume
{
    my $dir = eval { Path::Class::Dir->new('') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        my $result = eval { $dir->volume() };
        if ($@) { fail('Function crashed: ' . $@); } else {
            is($result, '', 'volume returns empty string for directory without a volume');
        }
    }
}

# Test case: Directory with a non-string volume
{
    my $dir = eval { Path::Class::Dir->new(undef) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        my $result = eval { $dir->volume() };
        if ($@) { fail('Function crashed: ' . $@); } else {
            is($result, '', 'volume returns empty string for directory with an undefined volume');
        }
    }
}

done_testing();