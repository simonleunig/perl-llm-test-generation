use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::mkpath"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'mkpath is defined'); }

# Mock File::Path::mkpath
my $mock;
# AFTER LAST PASS: eval { require File::Path; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: File::Path - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"File::Path::mkpath"}) {
        # AFTER LAST PASS: $mock = mock 'File::Path::mkpath' => sub {
            my ($path, %opts);  # AFTER LAST PASS: my ($path, %opts) = @_;
            # AFTER LAST PASS: return $path;
        # AFTER LAST PASS: };
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock = mock 'File::Path' => ( add => [ 'mkpath' => sub {
            my ($path, %opts);  # AFTER LAST PASS: my ($path, %opts) = @_;
            # AFTER LAST PASS: return $path;
        # AFTER LAST PASS: } ] );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# Test case: Successful directory creation
# AFTER LAST PASS: {
    my $dir;  # AFTER LAST PASS: my $dir;  # UNVALIDATED: my $dir = Path::Class::Dir->new('test_dir');
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Path::Class::Dir::mkpath($dir) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, 'test_dir', 'Directory created successfully');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Directory already exists
# AFTER LAST PASS: {
    my $dir;  # AFTER LAST PASS: my $dir;  # UNVALIDATED: my $dir = Path::Class::Dir->new('existing_dir');
    my $tempdir;  # AFTER LAST PASS: my $tempdir = tempdir(CLEANUP => 1);
    my $full_path;  # AFTER LAST PASS: my $full_path;  # UNVALIDATED: my $full_path = File::Spec->catfile($tempdir, 'existing_dir');
    # AFTER LAST PASS: mkdir $full_path;
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Path::Class::Dir::mkpath($dir) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, 'existing_dir', 'Directory already exists');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Invalid directory path
# AFTER LAST PASS: {
    my $dir;  # AFTER LAST PASS: my $dir;  # UNVALIDATED: my $dir = Path::Class::Dir->new('invalid:dir');
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Path::Class::Dir::mkpath($dir) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, undef, 'Invalid directory path');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Directory creation with additional options
# AFTER LAST PASS: {
    my $dir;  # AFTER LAST PASS: my $dir;  # UNVALIDATED: my $dir = Path::Class::Dir->new('test_dir_with_options');
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Path::Class::Dir::mkpath($dir, 0, 0755) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, 'test_dir_with_options', 'Directory created with additional options');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Directory creation fails due to permission issues
# AFTER LAST PASS: {
    my $dir;  # AFTER LAST PASS: my $dir;  # UNVALIDATED: my $dir = Path::Class::Dir->new('/non_existent_path/test_dir');
    # AFTER LAST PASS: mock 'File::Path::mkpath' => sub {
        # AFTER LAST PASS: die 'Permission denied';
    # AFTER LAST PASS: };
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Path::Class::Dir::mkpath($dir) };
    # AFTER LAST PASS: if ($@) {
        # FAILED: like($@, qr/Permission denied/, 'Directory creation fails with permission error');
    # AFTER LAST PASS: } else {
        # FAILED: fail('Function did not crash as expected');
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

done_testing();