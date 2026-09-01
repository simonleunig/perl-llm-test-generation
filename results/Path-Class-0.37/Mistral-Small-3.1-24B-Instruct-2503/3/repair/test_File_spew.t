use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock unmock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::spew"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'spew is defined'); }

# Mocking dependencies
my $mock;
eval { require Path::Class::File; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::File - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::File::open"}) {
        $mock = mock 'Path::Class::File' => (
            override => [
                open => sub {
                    my ($self, $mode) = @_;
                    return IO::File->new("> /dev/null") if $mode eq 'w';
                    return undef;
                },
            ],
        );
    } else {
        $mock = mock 'Path::Class::File' => (
            add => [
                open => sub {
                    my ($self, $mode) = @_;
                    return IO::File->new("> /dev/null") if $mode eq 'w';
                    return undef;
                },
            ],
        );
    }
}

# Test case: Writing a scalar to a file
{
    my ($fh, $filename) = tempfile();
    my $file = Path::Class::File->new($filename);
    my $content = 'test content';

    my $result = eval { $file->spew($content) };
    if ($@) { fail('Function crashed: ' . $@); } else { ok(1, 'Writing scalar content to file'); }

    open(my $read_fh, '<', $filename) or die "Could not open file '$filename' $!";
    my $read_content = do { local $/; <$read_fh> };
    close($read_fh);

    is($read_content, $content, 'Content written correctly');
}

# Test case: Writing an array reference to a file
{
    my ($fh, $filename) = tempfile();
    my $file = Path::Class::File->new($filename);
    my $content = ['line1', 'line2', 'line3'];

    my $result = eval { $file->spew($content) };
    if ($@) { fail('Function crashed: ' . $@); } else { ok(1, 'Writing array reference content to file'); }

    open(my $read_fh, '<', $filename) or die "Could not open file '$filename' $!";
    my $read_content = do { local $/; <$read_fh> };
    close($read_fh);

    is($read_content, join('', @$content), 'Content written correctly');
}

# Test case: Error handling - file cannot be opened
{
    my ($fh, $filename) = tempfile();
    my $file = Path::Class::File->new($filename);
    unmock 'Path::Class::File';
    mock 'Path::Class::File' => (
        open => sub { return undef; },
    );

    my $result = eval { $file->spew('test content') };
    like($@, qr/Can't write to/, 'Exception thrown when file cannot be opened');
}

# Test case: Error handling - writing to file fails
{
    my ($fh, $filename) = tempfile();
    my $file = Path::Class::File->new($filename);
    unmock 'Path::Class::File';
    mock 'Path::Class::File' => (
        open => sub {
            my ($self, $mode) = @_;
            return IO::File->new("> /dev/null") if $mode eq 'w';
            return undef;
        },
        print => sub { return 0; },
    );

    my $result = eval { $file->spew('test content') };
    like($@, qr/Can't write to/, 'Exception thrown when writing to file fails');
}

# Test case: Error handling - closing file handle fails
{
    my ($fh, $filename) = tempfile();
    my $file = Path::Class::File->new($filename);
    unmock 'Path::Class::File';
    mock 'Path::Class::File' => (
        open => sub {
            my ($self, $mode) = @_;
            return IO::File->new("> /dev/null") if $mode eq 'w';
            return undef;
        },
        close => sub { return 0; },
    );

    my $result = eval { $file->spew('test content') };
    like($@, qr/Can't write to/, 'Exception thrown when closing file handle fails');
}

done_testing();