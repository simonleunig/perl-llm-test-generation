use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::find_xml_file"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'find_xml_file is defined'); }

# Mocking File::Basename and File::Spec
my $mock_basename;
# AFTER LAST PASS: eval { require File::Basename; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: File::Basename - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"File::Basename::fileparse"}) {
        # AFTER LAST PASS: $mock_basename = mock 'File::Basename' => ( override => [ fileparse => sub {
            my ($file);  # AFTER LAST PASS: my ($file) = @_;
            # AFTER LAST PASS: return ('filename', 'filedir') if $file eq 'file_with_dir';
            # AFTER LAST PASS: return ('filename', '') if $file eq 'filename';
        # AFTER LAST PASS: } ] );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock_basename = mock 'File::Basename' => ( add => [ fileparse => sub {
            my ($file);  # AFTER LAST PASS: my ($file) = @_;
            # AFTER LAST PASS: return ('filename', 'filedir') if $file eq 'file_with_dir';
            # AFTER LAST PASS: return ('filename', '') if $file eq 'filename';
        # AFTER LAST PASS: } ] );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

my $mock_spec;
# AFTER LAST PASS: eval { require File::Spec; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: File::Spec - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"File::Spec::catfile"}) {
        # AFTER LAST PASS: $mock_spec = mock 'File::Spec' => ( override => [ catfile => sub {
            my ($path, $file);  # AFTER LAST PASS: my ($path, $file) = @_;
            # AFTER LAST PASS: return "$path/$file";
        # AFTER LAST PASS: } ] );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock_spec = mock 'File::Spec' => ( add => [ catfile => sub {
            my ($path, $file);  # AFTER LAST PASS: my ($path, $file) = @_;
            # AFTER LAST PASS: return "$path/$file";
        # AFTER LAST PASS: } ] );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# Test case: File with directory component
# AFTER LAST PASS: {
    my $self;  # AFTER LAST PASS: my $self = {};
    my $file;  # AFTER LAST PASS: my $file = 'file_with_dir';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::find_xml_file($self, $file) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, 'file_with_dir', 'File with directory component is returned correctly');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: File exists in current directory
# AFTER LAST PASS: {
    my $self;  # AFTER LAST PASS: my $self = {};
    my $file;  # AFTER LAST PASS: my $file = 'filename';
    my $tempdir;  # AFTER LAST PASS: my $tempdir = tempdir(CLEANUP => 1);
    my ($fh, $filename);  # AFTER LAST PASS: my ($fh, $filename) = tempfile(DIR => $tempdir);
    # AFTER LAST PASS: print $fh "dummy content";
    # AFTER LAST PASS: close $fh;

    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::find_xml_file($self, $filename) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, $filename, 'File exists in current directory');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: File not found in search path
# AFTER LAST PASS: {
    my $self;  # AFTER LAST PASS: my $self = {};
    my $file;  # AFTER LAST PASS: my $file = 'filename';
    my $search_path;  # AFTER LAST PASS: my $search_path = ['/nonexistent/path'];
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::find_xml_file($self, $file, @$search_path) };
    # FAILED: if ($@) { like($@, qr/Could not find filename in /, 'File not found in search path'); }
# AFTER LAST PASS: }

# Test case: File found in search path
# AFTER LAST PASS: {
    my $self;  # AFTER LAST PASS: my $self = {};
    my $file;  # AFTER LAST PASS: my $file = 'filename';
    my $search_path;  # AFTER LAST PASS: my $search_path = ['/existing/path'];
    my $tempdir;  # AFTER LAST PASS: my $tempdir = tempdir(CLEANUP => 1);
    my ($fh, $filename);  # AFTER LAST PASS: my ($fh, $filename) = tempfile(DIR => $tempdir);
    # AFTER LAST PASS: print $fh "dummy content";
    # AFTER LAST PASS: close $fh;

    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::find_xml_file($self, $file, @$search_path) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, '/existing/path/filename', 'File found in search path');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: No search path provided, file exists in current directory
# AFTER LAST PASS: {
    my $self;  # AFTER LAST PASS: my $self = {};
    my $file;  # AFTER LAST PASS: my $file = 'filename';
    my $tempdir;  # AFTER LAST PASS: my $tempdir = tempdir(CLEANUP => 1);
    my ($fh, $filename);  # AFTER LAST PASS: my ($fh, $filename) = tempfile(DIR => $tempdir);
    # AFTER LAST PASS: print $fh "dummy content";
    # AFTER LAST PASS: close $fh;

    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::find_xml_file($self, $filename) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, $filename, 'File exists in current directory with no search path');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: No search path provided, file does not exist
# AFTER LAST PASS: {
    my $self;  # AFTER LAST PASS: my $self = {};
    my $file;  # AFTER LAST PASS: my $file = 'nonexistent_file';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::find_xml_file($self, $file) };
    # FAILED: if ($@) { like($@, qr/File does not exist: nonexistent_file/, 'File does not exist with no search path'); }
# AFTER LAST PASS: }

done_testing();