use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::as_foreign"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'as_foreign is defined'); }

# Mock dependencies
my $mock_dir;
eval { require Path::Class::Dir; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Dir - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::Dir::as_foreign"}) {
        $mock_dir = mock 'Path::Class::Dir' => (
            override => [
                as_foreign => sub {
                    my ($self, $type) = @_;
                    return bless { dir => 'mocked_dir' }, 'Path::Class::Dir';
                },
            ],
        );
    } else {
        $mock_dir = mock 'Path::Class::Dir' => (
            add => [
                as_foreign => sub {
                    my ($self, $type) = @_;
                    return bless { dir => 'mocked_dir' }, 'Path::Class::Dir';
                },
            ],
        );
    }
}

my $mock_entity;
eval { require Path::Class::Entity; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Entity - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::Entity::new"}) {
        $mock_entity = mock 'Path::Class::Entity' => (
            override => [
                new => sub {
                    return bless {}, 'Path::Class::Entity';
                },
            ],
        );
    } else {
        $mock_entity = mock 'Path::Class::Entity' => (
            add => [
                new => sub {
                    return bless {}, 'Path::Class::Entity';
                },
            ],
        );
    }
}

my $mock_file;
eval { require Path::Class::File; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::File - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::File::_spec_class"}) {
        $mock_file = mock 'Path::Class::File' => (
            override => [
                _spec_class => sub {
                    my ($self, $type) = @_;
                    return 'Mock::SpecClass';
                },
            ],
        );
    } else {
        $mock_file = mock 'Path::Class::File' => (
            add => [
                _spec_class => sub {
                    my ($self, $type) = @_;
                    return 'Mock::SpecClass';
                },
            ],
        );
    }
}

# Test case 1: Normal operation with defined directory
{
    my $self = bless { dir => bless { dir => 'original_dir' }, 'Path::Class::Dir', file => 'file.txt' }, 'Path::Class::File';
    my $type = 'Unix';
    my $result = eval { $self->as_foreign($type) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(defined $result, 'Function returns result');
        is(ref($result), 'Path::Class::Entity', 'Result is an instance of Path::Class::Entity');
        is($result->{dir}->{dir}, 'mocked_dir', 'Directory part is converted correctly');
        is($result->{file}, 'file.txt', 'File part is preserved correctly');
    }
}

# Test case 2: Normal operation with undefined directory
{
    my $self = bless { dir => undef, file => 'file.txt' }, 'Path::Class::File';
    my $type = 'Unix';
    my $result = eval { $self->as_foreign($type) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(defined $result, 'Function returns result');
        is(ref($result), 'Path::Class::Entity', 'Result is an instance of Path::Class::Entity');
        is($result->{dir}, undef, 'Directory part is undefined');
        is($result->{file}, 'file.txt', 'File part is preserved correctly');
    }
}

# Test case 3: Edge case with invalid type
{
    my $self = bless { dir => bless { dir => 'original_dir' }, 'Path::Class::Dir', file => 'file.txt' }, 'Path::Class::File';
    my $type = 'InvalidOS';
    my $result = eval { $self->as_foreign($type) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(defined $result, 'Function returns result');
        is(ref($result), 'Path::Class::Entity', 'Result is an instance of Path::Class::Entity');
        is($result->{dir}->{dir}, 'mocked_dir', 'Directory part is converted correctly');
        is($result->{file}, 'file.txt', 'File part is preserved correctly');
    }
}

done_testing();