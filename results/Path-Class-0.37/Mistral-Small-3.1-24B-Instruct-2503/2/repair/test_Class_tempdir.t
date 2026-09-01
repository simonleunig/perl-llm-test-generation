use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw(tempdir);
use File::Spec;
use lib '.';
BEGIN { require Path::Class; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::tempdir"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'tempdir is defined'); }

# Mocking File::Temp::tempdir
my $mock;
eval { require File::Temp; };
if ($@) {
    # DEPENDENCY MISSING: File::Temp - mock skipped
} else {
    no strict 'refs';
    if (defined &{"File::Temp::tempdir"}) {
        $mock = mock 'File::Temp', override => [ tempdir => sub {
            my $dir = shift;
            return '/mock/tempdir' if $dir->{CLEANUP} == 1;
            return '/mock/tempdir/without_cleanup';
        } ];
    } else {
        $mock = mock 'File::Temp', add => [ tempdir => sub {
            my $dir = shift;
            return '/mock/tempdir' if $dir->{CLEANUP} == 1;
            return '/mock/tempdir/without_cleanup';
        } ];
    }
}

# Test case: Normal operation with cleanup
my $result = eval { Path::Class::tempdir(CLEANUP => 1) };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'tempdir returns result with cleanup');
    isa_ok($result, 'Path::Class::Dir', 'Result is a Path::Class::Dir object');
    is($result->stringify, '/mock/tempdir', 'Correct temporary directory path with cleanup');
}

# Test case: Normal operation without cleanup
$result = eval { Path::Class::tempdir() };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'tempdir returns result without cleanup');
    isa_ok($result, 'Path::Class::Dir', 'Result is a Path::Class::Dir object');
    is($result->stringify, '/mock/tempdir/without_cleanup', 'Correct temporary directory path without cleanup');
}

# Test case: Invalid input (unsupported option)
$result = eval { Path::Class::tempdir(INVALID_OPTION => 1) };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'tempdir returns result with invalid option');
    isa_ok($result, 'Path::Class::Dir', 'Result is a Path::Class::Dir object');
    is($result->stringify, '/mock/tempdir/without_cleanup', 'Correct temporary directory path with invalid option');
}

# Test case: File::Temp::tempdir fails (mocked to return undef)
mock 'File::Temp', override => [ tempdir => sub { return undef; } ];
$result = eval { Path::Class::tempdir() };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(!defined $result, 'tempdir returns undef when File::Temp::tempdir fails');
}

done_testing();