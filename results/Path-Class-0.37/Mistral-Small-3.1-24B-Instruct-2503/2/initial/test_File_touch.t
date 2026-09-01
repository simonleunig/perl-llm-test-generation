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

# Test case: File does not exist
{
    my ($fh, $filename) = tempfile();
    close $fh;
    unlink $filename;

    my $file = Path::Class::File->new($filename);
    my $result = eval { $file->touch };
    if ($@) { fail('touch crashed: ' . $@); } else { ok(1, 'touch did not crash when file does not exist'); }

    ok(-e $filename, 'File was created');
}

# Test case: File exists
{
    my ($fh, $filename) = tempfile();
    close $fh;

    my $file = Path::Class::File->new($filename);
    my $result = eval { $file->touch };
    if ($@) { fail('touch crashed: ' . $@); } else { ok(1, 'touch did not crash when file exists'); }

    my $mtime = (stat $filename)[9];
    sleep 1;  # Ensure time difference
    $result = eval { $file->touch };
    if ($@) { fail('touch crashed: ' . $@); } else { ok(1, 'touch did not crash when file exists'); }

    my $new_mtime = (stat $filename)[9];
    ok($new_mtime > $mtime, 'File modification time was updated');
}

# Test case: File cannot be written to (permissions issue)
{
    my $dir = tempdir(CLEANUP => 1);
    my $filename = File::Spec->catfile($dir, 'testfile');
    open my $fh, '>', $filename or die "Cannot create file: $!";
    close $fh;

    chmod 0444, $filename;  # Make file read-only

    my $file = Path::Class::File->new($filename);
    my $result = eval { $file->touch };
    if ($@) { ok(1, 'touch crashed as expected when file is read-only'); } else { fail('touch did not crash when file is read-only'); }
}

# Test case: File is a directory
{
    my $dir = tempdir(CLEANUP => 1);
    my $file = Path::Class::File->new($dir);
    my $result = eval { $file->touch };
    if ($@) { ok(1, 'touch crashed as expected when file is a directory'); } else { fail('touch did not crash when file is a directory'); }
}

done_testing();
