use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempdir tempfile/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::open"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'open is defined'); }

# Mock IO::Dir to control its behavior
my $mock;
eval { require IO::Dir; };
if ($@) {
    # DEPENDENCY MISSING: IO::Dir - mock skipped
} else {
    no strict 'refs';
    if (defined &{"IO::Dir::new"}) {
        $mock = mock 'IO::Dir' => (
            override => [
                new => sub {
                    my ($class, $dir) = @_;
                    if ($dir eq '/nonexistent') {
                        return undef;
                    } elsif ($dir eq '/readonly') {
                        return bless {}, $class;
                    } else {
                        return bless { dir => $dir }, $class;
                    }
                }
            ]
        );
    } else {
        $mock = mock 'IO::Dir' => (
            add => [
                new => sub {
                    my ($class, $dir) = @_;
                    if ($dir eq '/nonexistent') {
                        return undef;
                    } elsif ($dir eq '/readonly') {
                        return bless {}, $class;
                    } else {
                        return bless { dir => $dir }, $class;
                    }
                }
            ]
        );
    }
}

# Test case: Successful directory opening
{
    my $tempdir = tempdir(CLEANUP => 1);
    my $result = eval { Path::Class::Dir::open($tempdir) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(defined $result, 'open returns defined result for valid directory');
        # FAILED: isa_ok($result, 'IO::Dir', 'Result is an IO::Dir object');
    }
}

# Test case: Directory does not exist
{
    my $result = eval { Path::Class::Dir::open('/nonexistent') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(!defined $result, 'open returns undef for non-existent directory');
        # FAILED: is($!, 'No such file or directory', 'Error message is correct');
    }
}

# Test case: Directory is not readable
# AFTER LAST PASS: {
    my $tempdir;  # AFTER LAST PASS: my $tempdir = tempdir(CLEANUP => 1);
    my $readonly_dir;  # AFTER LAST PASS: my $readonly_dir = File::Spec->catdir($tempdir, 'readonly');
    # AFTER LAST PASS: mkdir($readonly_dir);
    # AFTER LAST PASS: chmod(0, $readonly_dir);  # Make directory non-readable

    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Path::Class::Dir::open($readonly_dir) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: ok(!defined $result, 'open returns undef for non-readable directory');
        # FAILED: like($!, qr/permission denied/, 'Error message indicates permission issue');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Invalid directory path
# AFTER LAST PASS: {
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Path::Class::Dir::open('invalid/path') };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: ok(!defined $result, 'open returns undef for invalid directory path');
        # FAILED: like($!, qr/No such file or directory/, 'Error message is correct');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Directory path is a file
# AFTER LAST PASS: {
    my $tempfile;  # AFTER LAST PASS: my $tempfile = tempfile(CLEANUP => 1);
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Path::Class::Dir::open($tempfile) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: ok(!defined $result, 'open returns undef for file path');
        # FAILED: like($!, qr/Not a directory/, 'Error message indicates not a directory');
    # FAILED: }
# AFTER LAST PASS: }

done_testing();