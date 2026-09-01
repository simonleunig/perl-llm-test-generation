use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class; }  # Use actual module name from package declaration

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::file"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'file is defined'); }

# Mock Path::Class::File->new
mock 'Path::Class::File' => (
    override => [
        new => sub {
            my $class = shift;
            my $path = join('/', @_);
            return bless { path => $path }, $class;
        }
    ]
);

# Test case: Normal operation with valid path components
my $result = eval { Path::Class::file('foo', 'bar', 'file.txt') };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'Function returns result');
    is($result->{path}, 'foo/bar/file.txt', 'Correct path constructed');
}

# Test case: Empty input
$result = eval { Path::Class::file() };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'Function returns result');
    is($result->{path}, '', 'Empty path constructed');
}

# Test case: Single component path
$result = eval { Path::Class::file('single_component.txt') };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'Function returns result');
    is($result->{path}, 'single_component.txt', 'Single component path constructed');
}

# Test case: Mixed components (strings and objects)
my $mock_component = bless { path => 'mock_component' }, 'Path::Class::File';
$result = eval { Path::Class::file('foo', $mock_component, 'file.txt') };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'Function returns result');
    is($result->{path}, 'foo/mock_component/file.txt', 'Mixed components path constructed');
}

# Test case: Invalid path components (handled by mock)
$result = eval { Path::Class::file('invalid', 'path', 'components') };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'Function returns result');
    is($result->{path}, 'invalid/path/components', 'Invalid path components handled');
}

done_testing();
