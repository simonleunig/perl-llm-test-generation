use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::spew_lines"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'spew_lines is defined'); }

# Mock the spew method
my $mock;
eval { require Path::Class::File; };
if ($@) {
    # DEPENDENCY MISSING: Path::Class::File - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Path::Class::File::spew"}) {
        $mock = mock 'Path::Class::File' => ( override => [ spew => sub {
            my ($self, %args) = @_;
            my $content = $args{content};
            my $file = $self->stringify;
            open my $fh, '>', $file or die "Cannot open file $file: $!";
            print $fh $content;
            close $fh;
            return 1;
        } ] );
    } else {
        $mock = mock 'Path::Class::File' => ( add => [ spew => sub {
            my ($self, %args) = @_;
            my $content = $args{content};
            my $file = $self->stringify;
            open my $fh, '>', $file or die "Cannot open file $file: $!";
            print $fh $content;
            close $fh;
            return 1;
        } ] );
    }
}

# Test case: Writing a scalar content
{
    my ($fh, $filename) = tempfile();
    my $file = Path::Class::File->new($filename);
    my $content = 'test content';
    my $result = eval { $file->spew_lines($content) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(defined $result, 'Function returns result for scalar content');
        open my $fh, '<', $filename or die "Cannot open file $filename: $!";
        my $written_content = do { local $/; <$fh> };
        close $fh;
        is($written_content, "$content$/", 'Scalar content written correctly with newline');
    }
}

# Test case: Writing an array reference content
{
    my ($fh, $filename) = tempfile();
    my $file = Path::Class::File->new($filename);
    my $content = ['line1', 'line2', 'line3'];
    my $result = eval { $file->spew_lines($content) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(defined $result, 'Function returns result for array reference content');
        open my $fh, '<', $filename or die "Cannot open file $filename: $!";
        my $written_content = do { local $/; <$fh> };
        close $fh;
        is($written_content, "line1$/line2$/line3$/", 'Array reference content written correctly with newlines');
    }
}

# Test case: Writing an empty scalar content
{
    my ($fh, $filename) = tempfile();
    my $file = Path::Class::File->new($filename);
    my $content = '';
    my $result = eval { $file->spew_lines($content) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(defined $result, 'Function returns result for empty scalar content');
        open my $fh, '<', $filename or die "Cannot open file $filename: $!";
        my $written_content = do { local $/; <$fh> };
        close $fh;
        is($written_content, "$/", 'Empty scalar content written correctly with newline');
    }
}

# Test case: Writing an empty array reference content
{
    my ($fh, $filename) = tempfile();
    my $file = Path::Class::File->new($filename);
    my $content = [];
    my $result = eval { $file->spew_lines($content) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(defined $result, 'Function returns result for empty array reference content');
        open my $fh, '<', $filename or die "Cannot open file $filename: $!";
        my $written_content = do { local $/; <$fh> };
        close $fh;
        is($written_content, "$/", 'Empty array reference content written correctly with newline');
    }
}

# Test case: Handling file write permission issues
{
    my $filename = File::Spec->catfile(tempdir(CLEANUP => 1), 'testfile');
    my $file = Path::Class::File->new($filename);
    my $content = 'test content';
    mock 'Path::Class::File', spew => sub {
        die "Permission denied";
    };
    my $result = eval { $file->spew_lines($content) };
    if ($@) {
        like($@, qr/Permission denied/, 'Function throws exception on permission denied');
    } else {
        fail('Function did not throw exception on permission denied');
    }
}

done_testing();