use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::new"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'new is defined'); }

# Mocking dependencies
my $mock_entity;
eval { require Path::Class::Entity; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Entity - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::Entity::new"}) {
        $mock_entity = mock 'Path::Class::Entity' => ( override => [ new => sub { bless {}, shift } ] );
    } else {
        $mock_entity = mock 'Path::Class::Entity' => ( add => [ new => sub { bless {}, shift } ] );
    }
}

my $mock_dir;
eval { require Path::Class::Dir; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Dir - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::Dir::new"}) {
        $mock_dir = mock 'Path::Class::Dir' => ( override => [ new => sub { bless {}, shift } ] );
    } else {
        $mock_dir = mock 'Path::Class::Dir' => ( add => [ new => sub { bless {}, shift } ] );
    }
}

my $mock_spec;
eval { require File::Spec; };
if ($@) {
    # DEPENDENCY MISSING: File::Spec - mock skipped
} else {
    no strict 'refs';
    if (defined &{"File::Spec::splitpath"}) {
        $mock_spec = mock 'File::Spec' => (
            override => [
                splitpath => sub {
                    my ($self, $path) = @_;
                    return ('', '', $path);
                },
                catpath => sub {
                    my ($self, $volume, $dirs, $file) = @_;
                    return $dirs . '/' . $file;
                },
            ],
        );
    } else {
        $mock_spec = mock 'File::Spec' => (
            add => [
                splitpath => sub {
                    my ($self, $path) = @_;
                    return ('', '', $path);
                },
                catpath => sub {
                    my ($self, $volume, $dirs, $file) = @_;
                    return $dirs . '/' . $file;
                },
            ],
        );
    }
}

# Test cases with eval protection

# Normal case: Relative path with multiple directory components
my $result = eval { Path::Class::File->new('foo', 'bar', 'baz.txt') };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'Function returns result for relative path');
    isa_ok($result, 'Path::Class::File', 'Result is a Path::Class::File object');
    is($result->{dir}, bless({}, 'Path::Class::Dir'), 'Directory component is correct');
    is($result->{file}, 'baz.txt', 'File component is correct');
}

# Normal case: Absolute path
$result = eval { Path::Class::File->new('/foo/bar/baz.txt') };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'Function returns result for absolute path');
    isa_ok($result, 'Path::Class::File', 'Result is a Path::Class::File object');
    is($result->{dir}, bless({}, 'Path::Class::Dir'), 'Directory component is correct');
    is($result->{file}, 'baz.txt', 'File component is correct');
}

# Edge case: Empty directory components
$result = eval { Path::Class::File->new('', 'baz.txt') };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'Function returns result for empty directory components');
    isa_ok($result, 'Path::Class::File', 'Result is a Path::Class::File object');
    is($result->{dir}, undef, 'Directory component is undef');
    is($result->{file}, 'baz.txt', 'File component is correct');
}

# Edge case: Single directory component
$result = eval { Path::Class::File->new('foo', 'baz.txt') };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'Function returns result for single directory component');
    isa_ok($result, 'Path::Class::File', 'Result is a Path::Class::File object');
    is($result->{dir}, bless({}, 'Path::Class::Dir'), 'Directory component is correct');
    is($result->{file}, 'baz.txt', 'File component is correct');
}

# Edge case: No directory components
$result = eval { Path::Class::File->new('baz.txt') };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'Function returns result for no directory components');
    isa_ok($result, 'Path::Class::File', 'Result is a Path::Class::File object');
    is($result->{dir}, undef, 'Directory component is undef');
    is($result->{file}, 'baz.txt', 'File component is correct');
}

done_testing();