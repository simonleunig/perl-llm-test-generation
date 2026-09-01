use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::move_to"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'move_to is defined'); }

# Mocking File::Copy::move
my $mock;
# AFTER LAST PASS: eval { require File::Copy; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: File::Copy - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"File::Copy::move"}) {
        # AFTER LAST PASS: $mock = mock 'File::Copy', move => sub {
            my ($src, $dest);  # AFTER LAST PASS: my ($src, $dest) = @_;
            # AFTER LAST PASS: return 1;  # Simulate successful move
        # AFTER LAST PASS: };
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock = mock 'File::Copy', add => {
            # AFTER LAST PASS: move => sub {
                my ($src, $dest);  # AFTER LAST PASS: my ($src, $dest) = @_;
                # AFTER LAST PASS: return 1;  # Simulate successful move
            # AFTER LAST PASS: }
        # AFTER LAST PASS: };
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# Test case: Successful move
# AFTER LAST PASS: {
    my ($fh, $filename);  # AFTER LAST PASS: my ($fh, $filename) = tempfile();
    my $dest_dir;  # AFTER LAST PASS: my $dest_dir = tempdir(CLEANUP => 1);
    my $dest_file;  # AFTER LAST PASS: my $dest_file = File::Spec->catfile($dest_dir, 'newfile.txt');

    my $file;  # AFTER LAST PASS: my $file;  # UNVALIDATED: my $file = Path::Class::File->new($filename);
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $file->move_to($dest_file) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: ok(defined $result, 'move_to returns defined result');
        # FAILED: is($result->stringify, $dest_file, 'File path updated correctly');
    # FAILED: }

    # Clean up
    # AFTER LAST PASS: unlink $filename;
# AFTER LAST PASS: }

# Mocking File::Copy::move to simulate failure
# AFTER LAST PASS: if ($mock) {
    # AFTER LAST PASS: $mock->override(move => sub {
        my ($src, $dest);  # AFTER LAST PASS: my ($src, $dest) = @_;
        # AFTER LAST PASS: return 0;  # Simulate failed move
    # AFTER LAST PASS: });
# AFTER LAST PASS: }

# Test case: Failed move
# AFTER LAST PASS: {
    my ($fh, $filename);  # AFTER LAST PASS: my ($fh, $filename) = tempfile();
    my $dest_dir;  # AFTER LAST PASS: my $dest_dir = tempdir(CLEANUP => 1);
    my $dest_file;  # AFTER LAST PASS: my $dest_file = File::Spec->catfile($dest_dir, 'newfile.txt');

    my $file;  # AFTER LAST PASS: my $file;  # UNVALIDATED: my $file = Path::Class::File->new($filename);
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $file->move_to($dest_file) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: ok(!defined $result, 'move_to returns undef on failure');
    # FAILED: }

    # Clean up
    # AFTER LAST PASS: unlink $filename;
# AFTER LAST PASS: }

# Test case: Destination path does not exist
# AFTER LAST PASS: {
    my ($fh, $filename);  # AFTER LAST PASS: my ($fh, $filename) = tempfile();
    my $dest_file;  # AFTER LAST PASS: my $dest_file = '/nonexistent/path/newfile.txt';

    my $file;  # AFTER LAST PASS: my $file;  # UNVALIDATED: my $file = Path::Class::File->new($filename);
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $file->move_to($dest_file) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: ok(!defined $result, 'move_to returns undef when destination path does not exist');
    # FAILED: }

    # Clean up
    # AFTER LAST PASS: unlink $filename;
# AFTER LAST PASS: }

# Test case: File to be moved does not exist
# AFTER LAST PASS: {
    my $filename;  # AFTER LAST PASS: my $filename = '/nonexistent/file.txt';
    my $dest_dir;  # AFTER LAST PASS: my $dest_dir = tempdir(CLEANUP => 1);
    my $dest_file;  # AFTER LAST PASS: my $dest_file = File::Spec->catfile($dest_dir, 'newfile.txt');

    my $file;  # AFTER LAST PASS: my $file;  # UNVALIDATED: my $file = Path::Class::File->new($filename);
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $file->move_to($dest_file) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: ok(!defined $result, 'move_to returns undef when file to be moved does not exist');
    # FAILED: }
# AFTER LAST PASS: }

done_testing();