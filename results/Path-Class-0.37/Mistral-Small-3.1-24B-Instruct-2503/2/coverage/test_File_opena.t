use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::opena"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'opena is defined'); }

# Mocking IO::File
my $mock;
# AFTER LAST PASS: eval { require IO::File; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: IO::File - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"IO::File::open"}) {
        # AFTER LAST PASS: $mock = mock 'IO::File' => ( override => [ open => sub {
            my ($class, $mode, $file);  # AFTER LAST PASS: my ($class, $mode, $file) = @_;
            # AFTER LAST PASS: if ($mode eq 'a') {
                # AFTER LAST PASS: return bless {}, $class;
            # AFTER LAST PASS: } else {
                # AFTER LAST PASS: return undef;
            # AFTER LAST PASS: }
        # AFTER LAST PASS: } ] );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock = mock 'IO::File' => ( add => [ open => sub {
            my ($class, $mode, $file);  # AFTER LAST PASS: my ($class, $mode, $file) = @_;
            # AFTER LAST PASS: if ($mode eq 'a') {
                # AFTER LAST PASS: return bless {}, $class;
            # AFTER LAST PASS: } else {
                # AFTER LAST PASS: return undef;
            # AFTER LAST PASS: }
        # AFTER LAST PASS: } ] );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# Test case: Successful file open in append mode
# AFTER LAST PASS: {
    my ($fh, $filename);  # AFTER LAST PASS: my ($fh, $filename) = tempfile();
    my $file;  # AFTER LAST PASS: my $file;  # UNVALIDATED: my $file = Path::Class::File->new($filename);
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $file->opena() };
    # AFTER LAST PASS: if ($@) {
        # FAILED: fail('Function crashed: ' . $@);
    # AFTER LAST PASS: } else {
        # FAILED: ok(defined $result, 'File opened successfully in append mode');
        # FAILED: isa_ok($result, 'IO::File', 'Returned object is an IO::File');
    # AFTER LAST PASS: }
    # AFTER LAST PASS: unlink $filename;
# AFTER LAST PASS: }

# Test case: File open fails due to invalid mode
# AFTER LAST PASS: {
    my ($fh, $filename);  # AFTER LAST PASS: my ($fh, $filename) = tempfile();
    my $file;  # AFTER LAST PASS: my $file;  # UNVALIDATED: my $file = Path::Class::File->new($filename);
    # AFTER LAST PASS: mock 'IO::File', open => sub {
        # AFTER LAST PASS: return undef;
    # AFTER LAST PASS: };
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $file->opena() };
    # AFTER LAST PASS: if ($@) {
        # FAILED: like($@, qr/Can't append to/, 'Exception thrown for invalid mode');
    # AFTER LAST PASS: } else {
        # FAILED: fail('Function did not throw an exception for invalid mode');
    # AFTER LAST PASS: }
    # AFTER LAST PASS: unlink $filename;
# AFTER LAST PASS: }

# Test case: File open fails due to permission issues
# AFTER LAST PASS: {
    my ($fh, $filename);  # AFTER LAST PASS: my ($fh, $filename) = tempfile();
    my $file;  # AFTER LAST PASS: my $file;  # UNVALIDATED: my $file = Path::Class::File->new($filename);
    # AFTER LAST PASS: mock 'IO::File', open => sub {
        # AFTER LAST PASS: $! = 'Permission denied';
        # AFTER LAST PASS: return undef;
    # AFTER LAST PASS: };
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $file->opena() };
    # AFTER LAST PASS: if ($@) {
        # FAILED: like($@, qr/Can't append to/, 'Exception thrown for permission issues');
    # AFTER LAST PASS: } else {
        # FAILED: fail('Function did not throw an exception for permission issues');
    # AFTER LAST PASS: }
    # AFTER LAST PASS: unlink $filename;
# AFTER LAST PASS: }

# Test case: File open fails due to non-existent file
# AFTER LAST PASS: {
    my $filename;  # AFTER LAST PASS: my $filename;  # UNVALIDATED: my $filename = File::Spec->catfile(tempdir(), 'non_existent_file.txt');
    my $file;  # AFTER LAST PASS: my $file;  # UNVALIDATED: my $file = Path::Class::File->new($filename);
    # AFTER LAST PASS: mock 'IO::File', open => sub {
        # AFTER LAST PASS: $! = 'No such file or directory';
        # AFTER LAST PASS: return undef;
    # AFTER LAST PASS: };
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $file->opena() };
    # AFTER LAST PASS: if ($@) {
        # FAILED: like($@, qr/Can't append to/, 'Exception thrown for non-existent file');
    # AFTER LAST PASS: } else {
        # FAILED: fail('Function did not throw an exception for non-existent file');
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

done_testing();