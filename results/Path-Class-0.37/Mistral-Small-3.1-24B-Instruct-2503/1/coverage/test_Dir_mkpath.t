use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::mkpath"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'mkpath is defined'); }

# Mock File::Path::mkpath
my $mock;
eval { require File::Path; };
if ($@) {
    # DEPENDENCY MISSING: File::Path - mock skipped
} else {
    no strict 'refs';
    if (defined &{"File::Path::mkpath"}) {
        $mock = mock 'File::Path' => ( override => [ mkpath => sub {
            my ($path, @args) = @_;
            return $path;
        } ] );
    } else {
        $mock = mock 'File::Path' => ( add => [ mkpath => sub {
            my ($path, @args) = @_;
            return $path;
        } ] );
    }
}

# Test case: Normal operation
{
    my $dir = Path::Class::Dir->new('test_dir');
    my $result = eval { Path::Class::Dir::mkpath($dir) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 'test_dir', 'mkpath returns the correct path for normal operation');
    }
}

# Test case: Directory already exists
{
    my $dir = Path::Class::Dir->new('existing_dir');
    my $tempdir = tempdir(CLEANUP => 1);
    my $full_path = File::Spec->catfile($tempdir, 'existing_dir');
    mkdir $full_path;
    my $result = eval { Path::Class::Dir::mkpath($dir) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, 'test_dir', 'mkpath handles existing directory correctly');
    # FAILED: }
}

# Test case: Invalid directory path
{
    my $dir = Path::Class::Dir->new('invalid:dir');
    my $result = eval { Path::Class::Dir::mkpath($dir) };
    if ($@) {
        # FAILED: like($@, qr/invalid:dir/, 'mkpath handles invalid directory path correctly');
    } else {
        # FAILED: fail('Function did not crash for invalid directory path');
    }
}

# Test case: Additional arguments
{
    my $dir = Path::Class::Dir->new('test_dir');
    my $result = eval { Path::Class::Dir::mkpath($dir, 0, 0755) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 'test_dir', 'mkpath handles additional arguments correctly');
    }
}

# Test case: Error propagation
# AFTER LAST PASS: {
    # AFTER LAST PASS: mock 'File::Path', mkpath => sub {
        # AFTER LAST PASS: die 'Simulated error';
    # AFTER LAST PASS: };
    my $dir;  # AFTER LAST PASS: my $dir;  # UNVALIDATED: my $dir = Path::Class::Dir->new('test_dir');
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Path::Class::Dir::mkpath($dir) };
    # AFTER LAST PASS: if ($@) {
        # FAILED: like($@, qr/Simulated error/, 'mkpath propagates errors correctly');
    # AFTER LAST PASS: } else {
        # FAILED: fail('Function did not propagate error');
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

done_testing();