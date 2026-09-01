use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::open"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'open is defined'); }

# Mock IO::Dir to control its behavior
mock 'IO::Dir' => (
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

# Test case: Successful directory opening
{
    my $tempdir = tempdir(CLEANUP => 1);
    my $result = eval { Path::Class::Dir::open($tempdir) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(defined $result, 'open returns defined result for valid directory');
        isa_ok($result, 'IO::Dir', 'Result is an IO::Dir object');
    }
}

# Test case: Directory does not exist
{
    my $result = eval { Path::Class::Dir::open('/nonexistent') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(!defined $result, 'open returns undef for non-existent directory');
        is($!, 'No such file or directory', 'Error message is correct');
    }
}

# Test case: Directory is not readable
{
    my $tempdir = tempdir(CLEANUP => 1);
    my $readonly_dir = File::Spec->catdir($tempdir, 'readonly');
    mkdir($readonly_dir);
    chmod(0, $readonly_dir);  # Make directory non-readable

    my $result = eval { Path::Class::Dir::open($readonly_dir) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(!defined $result, 'open returns undef for non-readable directory');
        like($!, qr/permission denied/, 'Error message indicates permission issue');
    }
}

# Test case: Invalid directory path
{
    my $result = eval { Path::Class::Dir::open('invalid/path') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(!defined $result, 'open returns undef for invalid directory path');
        like($!, qr/No such file or directory/, 'Error message is correct');
    }
}

# Test case: Directory path is a file
{
    my $tempfile = tempfile(CLEANUP => 1);
    my $result = eval { Path::Class::Dir::open($tempfile) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(!defined $result, 'open returns undef for file path');
        like($!, qr/Not a directory/, 'Error message indicates not a directory');
    }
}

done_testing();
