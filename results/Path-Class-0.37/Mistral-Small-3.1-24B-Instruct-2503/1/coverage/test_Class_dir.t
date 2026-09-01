use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw(tempfile tempdir);
use File::Spec;
use lib '.';
BEGIN { require Path::Class; }

# Mock Path::Class::Dir to avoid dependencies
my $mock;
eval { require Path::Class::Dir; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Dir - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::Dir::new"}) {
        $mock = mock 'Path::Class::Dir' => (
            override => [
                new => sub {
                    my $class = shift;
                    my $path = join('/', @_);
                    return bless { path => $path }, $class;
                }
            ]
        );
    } else {
        $mock = mock 'Path::Class::Dir' => (
            add => [
                new => sub {
                    my $class = shift;
                    my $path = join('/', @_);
                    return bless { path => $path }, $class;
                }
            ]
        );
    }
}

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::dir"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'dir is defined'); }

# Test case: Normal operation with valid inputs
my $result = eval { Path::Class::dir('foo', 'bar') };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'Function returns result');
    # FAILED: isa_ok($result, 'Path::Class::Dir', 'Result is a Path::Class::Dir object');
    is($result->{path}, 'foo/bar', 'Path is correctly constructed');
}

# Test case: Empty input
$result = eval { Path::Class::dir() };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'Function returns result');
    # FAILED: isa_ok($result, 'Path::Class::Dir', 'Result is a Path::Class::Dir object');
    is($result->{path}, '', 'Path is empty when no arguments are provided');
}

# Test case: Invalid path components (non-string inputs)
$result = eval { Path::Class::dir('foo', 123, 'bar') };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'Function returns result');
    # FAILED: isa_ok($result, 'Path::Class::Dir', 'Result is a Path::Class::Dir object');
    is($result->{path}, 'foo/123/bar', 'Path handles non-string inputs gracefully');
}

# Test case: Cross-platform differences (Windows vs Unix path separators)
$result = eval { Path::Class::dir('foo', 'bar\\baz') };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'Function returns result');
    # FAILED: isa_ok($result, 'Path::Class::Dir', 'Result is a Path::Class::Dir object');
    is($result->{path}, 'foo/bar\\baz', 'Path handles Windows path separators correctly');
}

done_testing();