use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::as_foreign"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'as_foreign is defined'); }

# Mocking dependencies
my $mock;
eval { require Path::Class::Entity; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Entity - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::Entity::new"}) {
        $mock = mock 'Path::Class::Entity' => (
            override => [
                new => sub { bless {}, 'Path::Class::Dir' },
            ],
        );
    } else {
        $mock = mock 'Path::Class::Entity' => (
            add => [
                new => sub { bless {}, 'Path::Class::Dir' },
            ],
        );
    }
}

eval { require Path::Class::Dir; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Dir - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::Dir::_spec_class"}) {
        $mock = mock 'Path::Class::Dir' => (
            override => [
                _spec_class => sub { 'File::Spec::Unix' },
                _spec => sub {
                    my $self = shift;
                    bless { updir => '..' }, 'File::Spec::Unix';
                },
            ],
        );
    } else {
        $mock = mock 'Path::Class::Dir' => (
            add => [
                _spec_class => sub { 'File::Spec::Unix' },
                _spec => sub {
                    my $self = shift;
                    bless { updir => '..' }, 'File::Spec::Unix';
                },
            ],
        );
    }
}

# Test case 1: Normal operation with valid type
{
    my $self = bless {
        volume => 'C',
        dirs => ['dir1', 'dir2'],
    }, 'Path::Class::Dir';

    my $result = eval { $self->as_foreign('Unix') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(defined $result, 'Function returns result');
        is($result->{volume}, 'C', 'Volume is correctly cloned');
        is_deeply($result->{dirs}, ['dir1', 'dir2'], 'Dirs are correctly cloned');
    }
}

# Test case 2: Edge case with empty dirs
{
    my $self = bless {
        volume => 'C',
        dirs => [],
    }, 'Path::Class::Dir';

    my $result = eval { $self->as_foreign('Unix') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(defined $result, 'Function returns result');
        is($result->{volume}, 'C', 'Volume is correctly cloned');
        is_deeply($result->{dirs}, [], 'Dirs are correctly cloned');
    }
}

# Test case 3: Edge case with single dir
{
    my $self = bless {
        volume => 'C',
        dirs => ['single_dir'],
    }, 'Path::Class::Dir';

    my $result = eval { $self->as_foreign('Unix') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(defined $result, 'Function returns result');
        is($result->{volume}, 'C', 'Volume is correctly cloned');
        is_deeply($result->{dirs}, ['single_dir'], 'Dirs are correctly cloned');
    }
}

# Test case 4: Edge case with updir in dirs
{
    my $self = bless {
        volume => 'C',
        dirs => ['..', 'dir1'],
    }, 'Path::Class::Dir';

    my $result = eval { $self->as_foreign('Unix') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(defined $result, 'Function returns result');
        is($result->{volume}, 'C', 'Volume is correctly cloned');
        is_deeply($result->{dirs}, ['..', 'dir1'], 'Dirs are correctly mapped');
    }
}

# Test case 5: Edge case with no volume
{
    my $self = bless {
        volume => undef,
        dirs => ['dir1', 'dir2'],
    }, 'Path::Class::Dir';

    my $result = eval { $self->as_foreign('Unix') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(defined $result, 'Function returns result');
        is($result->{volume}, undef, 'Volume is correctly cloned');
        is_deeply($result->{dirs}, ['dir1', 'dir2'], 'Dirs are correctly cloned');
    }
}

done_testing();