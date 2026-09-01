use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::foreign_file"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'foreign_file is defined'); }

# Mock Path::Class::File->new_foreign
my $mock;
eval { require Path::Class::File; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::File - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::File::new_foreign"}) {
        $mock = mock 'Path::Class::File' => (
            override => [
                new_foreign => sub {
                    my ($class, @args) = @_;
                    return bless { args => \@args }, $class;
                }
            ]
        );
    } else {
        $mock = mock 'Path::Class::File' => (
            add => [
                new_foreign => sub {
                    my ($class, @args) = @_;
                    return bless { args => \@args }, $class;
                }
            ]
        );
    }
}

# Test case: Valid input
my $result = eval { Path::Class::foreign_file('Win32', 'C:\\path\\to\\file.txt') };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'Function returns result for valid input');
    isa_ok($result, 'Path::Class::File', 'Result is a Path::Class::File object');
    is_deeply($result->{args}, ['Win32', 'C:\\path\\to\\file.txt'], 'Arguments passed correctly');
}

# Test case: Invalid file system type
$result = eval { Path::Class::foreign_file('InvalidFS', 'C:\\path\\to\\file.txt') };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'Function returns result for invalid file system type');
    isa_ok($result, 'Path::Class::File', 'Result is a Path::Class::File object');
    is_deeply($result->{args}, ['InvalidFS', 'C:\\path\\to\\file.txt'], 'Arguments passed correctly');
}

# Test case: Malformed path string
$result = eval { Path::Class::foreign_file('Win32', 'invalid\\path\\string') };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'Function returns result for malformed path string');
    isa_ok($result, 'Path::Class::File', 'Result is a Path::Class::File object');
    is_deeply($result->{args}, ['Win32', 'invalid\\path\\string'], 'Arguments passed correctly');
}

# Test case: Empty path string
$result = eval { Path::Class::foreign_file('Win32', '') };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'Function returns result for empty path string');
    isa_ok($result, 'Path::Class::File', 'Result is a Path::Class::File object');
    is_deeply($result->{args}, ['Win32', ''], 'Arguments passed correctly');
}

# Test case: No arguments
$result = eval { Path::Class::foreign_file() };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'Function returns result for no arguments');
    isa_ok($result, 'Path::Class::File', 'Result is a Path::Class::File object');
    is_deeply($result->{args}, [], 'Arguments passed correctly');
}

done_testing();