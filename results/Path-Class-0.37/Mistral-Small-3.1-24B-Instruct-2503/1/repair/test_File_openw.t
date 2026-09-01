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

# Test case: Successful file open in write mode
{
    my ($fh, $filename) = tempfile();
    my $file = Path::Class::File->new($filename);
    my $result = eval { $file->openw() };
    if ($@) {
        fail('Function crashed: ' . $@);
    } else {
        ok(defined $result, 'openw returns an IO::File object');
        isa_ok($result, 'IO::File', 'Returned object is an IO::File');
    }
    unlink $filename;
}

# Test case: File open fails due to invalid mode
{
    my ($fh, $filename) = tempfile();
    my $file = Path::Class::File->new($filename);
    mock 'IO::File', open => sub { return undef; };
    my $result = eval { $file->openw() };
    if ($@) {
        like($@, qr/Can't write to .*: $!/, 'openw throws an exception on failure');
    } else {
        fail('Function did not throw an exception on failure');
    }
    unlink $filename;
}

# Test case: File open fails due to permission issues
{
    my ($fh, $filename) = tempfile();
    my $file = Path::Class::File->new($filename);
    mock 'IO::File', open => sub { return undef; };
    my $result = eval { $file->openw() };
    if ($@) {
        like($@, qr/Can't write to .*: $!/, 'openw throws an exception on permission failure');
    } else {
        fail('Function did not throw an exception on permission failure');
    }
    unlink $filename;
}

# Test case: File open fails due to file being open in another process
{
    my ($fh, $filename) = tempfile();
    my $file = Path::Class::File->new($filename);
    mock 'IO::File', open => sub { return undef; };
    my $result = eval { $file->openw() };
    if ($@) {
        like($@, qr/Can't write to .*: $!/, 'openw throws an exception on file busy');
    } else {
        fail('Function did not throw an exception on file busy');
    }
    unlink $filename;
}

done_testing();