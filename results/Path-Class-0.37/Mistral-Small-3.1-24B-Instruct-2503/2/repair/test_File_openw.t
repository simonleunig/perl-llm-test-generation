use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::openw"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'openw is defined'); }

# Mocking IO::File
my $mock;
eval { require IO::File; };
if ($@) {
    # DEPENDENCY MISSING: IO::File - mock skipped
} else {
    no strict 'refs';
    if (defined &{"IO::File::open"}) {
        $mock = mock 'IO::File', override => [ open => sub {
            my ($class, $mode) = @_;
            if ($mode eq 'w') {
                return bless {}, $class;
            } else {
                return undef;
            }
        } ];
    } else {
        $mock = mock 'IO::File', add => [ open => sub {
            my ($class, $mode) = @_;
            if ($mode eq 'w') {
                return bless {}, $class;
            } else {
                return undef;
            }
        } ];
    }
}

# Test case: Successful file open for writing
{
    my ($fh, $filename) = tempfile();
    my $file = Path::Class::File->new($filename);
    my $result = eval { $file->openw() };
    if ($@) {
        fail('Function crashed: ' . $@);
    } else {
        ok(defined $result, 'openw returns an IO::File object when successful');
        isa_ok($result, 'IO::File', 'Returned object is an IO::File');
    }
    unlink $filename;
}

# Test case: File open fails due to invalid path
{
    my $invalid_file = Path::Class::File->new('/invalid/path/file.txt');
    my $result = eval { $invalid_file->openw() };
    if ($@) {
        like($@, qr/Can't write to \/invalid\/path\/file\.txt: No such file or directory/, 'openw throws an error for invalid path');
    } else {
        fail('Function did not crash as expected');
    }
}

# Test case: File open fails due to permission issues
{
    my $tempdir = tempdir(CLEANUP => 1);
    my $filename = File::Spec->catfile($tempdir, 'testfile.txt');
    my $file = Path::Class::File->new($filename);
    chmod 0444, $filename;  # Make the file read-only

    my $result = eval { $file->openw() };
    if ($@) {
        like($@, qr/Can't write to $filename: Permission denied/, 'openw throws an error for permission issues');
    } else {
        fail('Function did not crash as expected');
    }
    chmod 0644, $filename;  # Restore permissions
}

# Test case: File open fails due to non-existent directory
{
    my $nonexistent_dir = '/nonexistent/dir';
    my $filename = File::Spec->catfile($nonexistent_dir, 'testfile.txt');
    my $file = Path::Class::File->new($filename);
    my $result = eval { $file->openw() };
    if ($@) {
        like($@, qr/Can't write to $filename: No such file or directory/, 'openw throws an error for non-existent directory');
    } else {
        fail('Function did not crash as expected');
    }
}

done_testing();