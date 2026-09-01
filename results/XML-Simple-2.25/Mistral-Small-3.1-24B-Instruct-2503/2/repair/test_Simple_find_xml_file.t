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
eval { require File::Basename; };
if ($@) {
    # DEPENDENCY MISSING: File::Basename - mock skipped
} else {
    no strict 'refs';
    if (defined &{"File::Basename::fileparse"}) {
        $mock_basename = mock 'File::Basename' => ( override => [ fileparse => sub {
            my ($file) = @_;
            return ('filename', 'filedir') if $file eq 'file_with_dir';
            return ('filename', '') if $file eq 'filename';
        } ] );
    } else {
        $mock_basename = mock 'File::Basename' => ( add => [ fileparse => sub {
            my ($file) = @_;
            return ('filename', 'filedir') if $file eq 'file_with_dir';
            return ('filename', '') if $file eq 'filename';
        } ] );
    }
}

my $mock_spec;
eval { require File::Spec; };
if ($@) {
    # DEPENDENCY MISSING: File::Spec - mock skipped
} else {
    no strict 'refs';
    if (defined &{"File::Spec::catfile"}) {
        $mock_spec = mock 'File::Spec' => ( override => [ catfile => sub {
            my ($path, $file) = @_;
            return "$path/$file";
        } ] );
    } else {
        $mock_spec = mock 'File::Spec' => ( add => [ catfile => sub {
            my ($path, $file) = @_;
            return "$path/$file";
        } ] );
    }
}

# Test case: File with directory component
{
    my $self = {};
    my $file = 'file_with_dir';
    my $result = eval { XML::Simple::find_xml_file($self, $file) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 'file_with_dir', 'File with directory component is returned correctly');
    }
}

# Test case: File exists in current directory
{
    my $self = {};
    my $file = 'filename';
    my $tempdir = tempdir(CLEANUP => 1);
    my ($fh, $filename) = tempfile(DIR => $tempdir);
    print $fh "dummy content";
    close $fh;

    my $result = eval { XML::Simple::find_xml_file($self, $filename) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, $filename, 'File exists in current directory');
    }
}

# Test case: File not found in search path
{
    my $self = {};
    my $file = 'filename';
    my $search_path = ['/nonexistent/path'];
    my $result = eval { XML::Simple::find_xml_file($self, $file, @$search_path) };
    if ($@) { like($@, qr/Could not find filename in /, 'File not found in search path'); }
}

# Test case: File found in search path
{
    my $self = {};
    my $file = 'filename';
    my $search_path = ['/existing/path'];
    my $tempdir = tempdir(CLEANUP => 1);
    my ($fh, $filename) = tempfile(DIR => $tempdir);
    print $fh "dummy content";
    close $fh;

    my $result = eval { XML::Simple::find_xml_file($self, $file, @$search_path) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, '/existing/path/filename', 'File found in search path');
    }
}

# Test case: No search path provided, file exists in current directory
{
    my $self = {};
    my $file = 'filename';
    my $tempdir = tempdir(CLEANUP => 1);
    my ($fh, $filename) = tempfile(DIR => $tempdir);
    print $fh "dummy content";
    close $fh;

    my $result = eval { XML::Simple::find_xml_file($self, $filename) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, $filename, 'File exists in current directory with no search path');
    }
}

# Test case: No search path provided, file does not exist
{
    my $self = {};
    my $file = 'nonexistent_file';
    my $result = eval { XML::Simple::find_xml_file($self, $file) };
    if ($@) { like($@, qr/File does not exist: nonexistent_file/, 'File does not exist with no search path'); }
}

done_testing();