use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::foreign_dir"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'foreign_dir is defined'); }

# Mock Path::Class::Dir
my $mock;
eval { require Path::Class::Dir; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::Dir - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::Dir::new_foreign"}) {
        $mock = mock 'Path::Class::Dir' => (
            override => [
                new_foreign => sub {
                    my ($class, @args) = @_;
                    return bless { args => \@args }, $class;
                },
            ],
        );
    } else {
        $mock = mock 'Path::Class::Dir' => (
            add => [
                new_foreign => sub {
                    my ($class, @args) = @_;
                    return bless { args => \@args }, $class;
                },
            ],
        );
    }
}

# Test case: Normal operation with valid input
my $result = eval { Path::Class::foreign_dir('Mac', ':foo:bar') };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'foreign_dir returns result');
    isa_ok($result, 'Path::Class::Dir', 'Result is a Path::Class::Dir object');
    is_deeply($result->{args}, ['Mac', ':foo:bar'], 'Arguments passed correctly');
}

# Test case: Empty input
$result = eval { Path::Class::foreign_dir() };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'foreign_dir returns result with empty input');
    isa_ok($result, 'Path::Class::Dir', 'Result is a Path::Class::Dir object');
    is_deeply($result->{args}, [], 'Arguments passed correctly');
}

# Test case: Single empty string input
$result = eval { Path::Class::foreign_dir('') };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'foreign_dir returns result with single empty string input');
    isa_ok($result, 'Path::Class::Dir', 'Result is a Path::Class::Dir object');
    is_deeply($result->{args}, [''], 'Arguments passed correctly');
}

# Test case: Invalid path format (should handle gracefully)
$result = eval { Path::Class::foreign_dir('InvalidFS', 'invalid:path') };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'foreign_dir returns result with invalid path format');
    isa_ok($result, 'Path::Class::Dir', 'Result is a Path::Class::Dir object');
    is_deeply($result->{args}, ['InvalidFS', 'invalid:path'], 'Arguments passed correctly');
}

# Test case: Unsupported foreign file system
$result = eval { Path::Class::foreign_dir('UnsupportedFS', 'path') };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'foreign_dir returns result with unsupported foreign file system');
    isa_ok($result, 'Path::Class::Dir', 'Result is a Path::Class::Dir object');
    is_deeply($result->{args}, ['UnsupportedFS', 'path'], 'Arguments passed correctly');
}

done_testing();