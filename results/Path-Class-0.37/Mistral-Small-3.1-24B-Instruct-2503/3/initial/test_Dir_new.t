use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::new"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'new is defined'); }

# Mock dependencies
mock 'Path::Class::Entity' => (
    override => [
        new => sub { bless {}, 'Path::Class::Entity' },
    ],
);

mock 'Scalar::Util' => (
    override => [
        blessed => sub { return 1 if $_[0] =~ /Path::Class::Dir/; return 0; },
    ],
);

mock 'Path::Class::Dir' => (
    override => [
        _spec => sub { bless {}, 'Path::Class::File' },
        curdir => sub { return 'current_dir' },
        rootdir => sub { return 'root_dir' },
        splitpath => sub { return ('volume', 'dirs') },
        canonpath => sub { return 'canon_path' },
        splitdir => sub { return ['dir1', 'dir2'] },
    ],
);

# Test cases with eval protection

# Test with no arguments
my $result = eval { Path::Class::Dir->new() };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'Function returns result with no arguments');
    is($result->{dirs}, ['dir1', 'dir2'], 'Correct dirs with no arguments');
}

# Test with undef argument
$result = eval { Path::Class::Dir->new(undef) };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(!defined $result, 'Function returns undef with undef argument');
}

# Test with empty string as the first argument
$result = eval { Path::Class::Dir->new('') };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'Function returns result with empty string argument');
    is($result->{volume}, 'volume', 'Correct volume with empty string argument');
    is($result->{dirs}, ['dir1', 'dir2'], 'Correct dirs with empty string argument');
}

# Test with a single directory name
$result = eval { Path::Class::Dir->new('test_dir') };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'Function returns result with single directory name');
    is($result->{volume}, 'volume', 'Correct volume with single directory name');
    is($result->{dirs}, ['dir1', 'dir2'], 'Correct dirs with single directory name');
}

# Test with a Path::Class::Dir object
my $dir_obj = bless { volume => 'volume', dirs => ['dir1', 'dir2'] }, 'Path::Class::Dir';
$result = eval { Path::Class::Dir->new($dir_obj) };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'Function returns result with Path::Class::Dir object');
    is($result->{volume}, 'volume', 'Correct volume with Path::Class::Dir object');
    is($result->{dirs}, ['dir1', 'dir2'], 'Correct dirs with Path::Class::Dir object');
}

# Test with multiple arguments
$result = eval { Path::Class::Dir->new('test_dir1', 'test_dir2') };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'Function returns result with multiple arguments');
    is($result->{volume}, 'volume', 'Correct volume with multiple arguments');
    is($result->{dirs}, ['dir1', 'dir2', 'dir1', 'dir2'], 'Correct dirs with multiple arguments');
}

done_testing();
