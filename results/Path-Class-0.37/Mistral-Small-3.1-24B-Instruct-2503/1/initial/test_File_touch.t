use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::touch"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'touch is defined'); }

# Mocking dependencies
mock 'Path::Class::Entity' => (
    openw => sub {
        my $self = shift;
        my $file = $self->stringify;
        open my $fh, '>', $file or die "Cannot create file: $!";
        close $fh;
    }
);

mock 'Path::Class::File' => (
    stringify => sub {
        my $self = shift;
        return $self;
    }
);

# Test case: File does not exist
{
    my ($fh, $filename) = tempfile();
    close $fh;
    unlink $filename;

    my $file = Path::Class::File->new($filename);
    my $result = eval { $file->touch };
    if ($@) { fail('touch crashed: ' . $@); } else {
        ok(-e $filename, 'File created when it does not exist');
        ok(-f $filename, 'File is a regular file');
    }
}

# Test case: File exists
{
    my ($fh, $filename) = tempfile();
    close $fh;

    my $file = Path::Class::File->new($filename);
    my $result = eval { $file->touch };
    if ($@) { fail('touch crashed: ' . $@); } else {
        ok(-e $filename, 'File exists');
        ok(-f $filename, 'File is a regular file');
    }
}

# Test case: File cannot be written to (permissions issue)
{
    my ($fh, $filename) = tempfile();
    close $fh;
    chmod 0000, $filename;

    my $file = Path::Class::File->new($filename);
    my $result = eval { $file->touch };
    if ($@) {
        like($@, qr/cannot create file/, 'touch fails with permissions issue');
    } else {
        fail('touch did not fail with permissions issue');
    }
}

# Clean up
unlink $filename;

done_testing();
