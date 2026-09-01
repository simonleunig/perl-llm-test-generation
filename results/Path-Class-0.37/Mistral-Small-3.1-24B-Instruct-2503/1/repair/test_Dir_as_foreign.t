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
        $mock = mock 'Path::Class::Entity' => ( override => [ new => sub { bless {}, 'Path::Class::Entity' } ] );
    } else {
        $mock = mock 'Path::Class::Entity' => ( add => [ new => sub { bless {}, 'Path::Class::Entity' } ] );
    }
}

eval { require Path::Class::Dir; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Dir - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::Dir::_spec_class"}) {
        $mock = mock 'Path::Class::Dir' => ( override => [ _spec_class => sub { return 'File::Spec::Unix' } ] );
    } else {
        $mock = mock 'Path::Class::Dir' => ( add => [ _spec_class => sub { return 'File::Spec::Unix' } ] );
    }
    if (defined &{"Path::Class::Dir::_spec"}) {
        $mock = mock 'Path::Class::Dir' => ( override => [ _spec => sub { return bless { updir => '..' }, 'File::Spec::Unix' } ] );
    } else {
        $mock = mock 'Path::Class::Dir' => ( add => [ _spec => sub { return bless { updir => '..' }, 'File::Spec::Unix' } ] );
    }
}

# Test case 1: Normal operation with valid type
{
    my $self = bless {
        file_spec_class => 'File::Spec::Unix',
        volume => 'C',
        dirs => ['dir1', 'dir2'],
    }, 'Path::Class::Dir';

    my $result = eval { $self->as_foreign('Unix') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(defined $result, 'Function returns result');
        isa_ok($result, 'Path::Class::Entity', 'Result is a Path::Class::Entity object');
        is($result->{volume}, 'C', 'Volume is correctly cloned');
        is_deeply($result->{dirs}, ['dir1', 'dir2'], 'Dirs are correctly cloned');
    }
}

# Test case 2: Edge case with empty dirs
{
    my $self = bless {
        file_spec_class => 'File::Spec::Unix',
        volume => 'C',
        dirs => [],
    }, 'Path::Class::Dir';

    my $result = eval { $self->as_foreign('Unix') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(defined $result, 'Function returns result');
        isa_ok($result, 'Path::Class::Entity', 'Result is a Path::Class::Entity object');
        is($result->{volume}, 'C', 'Volume is correctly cloned');
        is_deeply($result->{dirs}, [], 'Dirs are correctly cloned');
    }
}

# Test case 3: Edge case with updir in dirs
{
    my $self = bless {
        file_spec_class => 'File::Spec::Unix',
        volume => 'C',
        dirs => ['..', 'dir1'],
    }, 'Path::Class::Dir';

    my $result = eval { $self->as_foreign('Unix') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(defined $result, 'Function returns result');
        isa_ok($result, 'Path::Class::Entity', 'Result is a Path::Class::Entity object');
        is($result->{volume}, 'C', 'Volume is correctly cloned');
        is_deeply($result->{dirs}, ['..', 'dir1'], 'Dirs are correctly mapped');
    }
}

# Test case 4: Edge case with invalid type (should not crash but return a valid object)
{
    my $self = bless {
        file_spec_class => 'File::Spec::Unix',
        volume => 'C',
        dirs => ['dir1', 'dir2'],
    }, 'Path::Class::Dir';

    my $result = eval { $self->as_foreign('InvalidType') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(defined $result, 'Function returns result');
        isa_ok($result, 'Path::Class::Entity', 'Result is a Path::Class::Entity object');
        is($result->{volume}, 'C', 'Volume is correctly cloned');
        is_deeply($result->{dirs}, ['dir1', 'dir2'], 'Dirs are correctly cloned');
    }
}

done_testing();