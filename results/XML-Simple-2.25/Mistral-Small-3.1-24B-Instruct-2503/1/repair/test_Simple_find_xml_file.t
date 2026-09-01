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
mock 'File::Basename', fileparse => sub {
    my ($file) = @_;
    return ('filename', 'filedir') if $file eq 'file_with_dir';
    return ('filename', '') if $file eq 'filename';
};

mock 'File::Spec', catfile => sub {
    my ($path, $file) = @_;
    return "$path/$file";
};

# Test case: File with directory component
{
    my $self = {};
    my $file = 'file_with_dir';
    my @search_path = ('/path1', '/path2');

    my $result = eval { XML::Simple::find_xml_file($self, $file, @search_path) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 'file_with_dir', 'File with directory component is returned as is');
    }
}

# Test case: File exists in the current directory
{
    my $self = {};
    my $file = 'filename';
    my @search_path = ();

    my $tempdir = tempdir(CLEANUP => 1);
    my ($fh, $filename) = tempfile(DIR => $tempdir);
    print $fh "dummy content";
    close $fh;

    my $result = eval { XML::Simple::find_xml_file($self, $filename, @search_path) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, $filename, 'File exists in the current directory');
    }
}

# Test case: File does not exist in the current directory
{
    my $self = {};
    my $file = 'nonexistent_file';
    my @search_path = ();

    my $result = eval { XML::Simple::find_xml_file($self, $file, @search_path) };
    if ($@) { like($@, qr/File does not exist: nonexistent_file/, 'File does not exist in the current directory'); }
}

# Test case: File found in the search path
{
    my $self = {};
    my $file = 'filename';
    my @search_path = ('/path1', '/path2');

    mock 'File::Spec', catfile => sub {
        my ($path, $file) = @_;
        return "$path/$file" if $path eq '/path1';
    };

    my $result = eval { XML::Simple::find_xml_file($self, $file, @search_path) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, '/path1/filename', 'File found in the search path');
    }
}

# Test case: File not found in the search path
{
    my $self = {};
    my $file = 'filename';
    my @search_path = ('/path1', '/path2');

    my $result = eval { XML::Simple::find_xml_file($self, $file, @search_path) };
    if ($@) { like($@, qr/Could not find filename in /path1:/path2/, 'File not found in the search path'); }
}

done_testing();