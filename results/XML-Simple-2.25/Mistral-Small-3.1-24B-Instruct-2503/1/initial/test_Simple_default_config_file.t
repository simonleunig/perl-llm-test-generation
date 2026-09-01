use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }  # Use actual module name from package declaration

# Mock File::Basename::fileparse to control its behavior
mock 'File::Basename', fileparse => sub {
    my ($file, $suffix) = @_;
    return ('script_name', '/path/to/script', '.pl');
};

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::default_config_file"} };
if ($@) {
    fail('Symbol check crashed: ' . $@);
} else {
    ok($symbol_check, 'default_config_file is defined');
}

# Test case: Normal operation
{
    my $self = bless { opt => { searchpath => [] } }, 'XML::Simple';
    my $result = eval { XML::Simple::default_config_file($self) };
    if ($@) {
        fail('Function crashed: ' . $@);
    } else {
        is($result, 'script_name.xml', 'default_config_file returns correct file name');
        is_deeply($self->{opt}->{searchpath}, ['/path/to/script'], 'searchpath is updated correctly');
    }
}

# Test case: Script directory is not accessible (mocked to return undef)
{
    mock 'File::Basename', fileparse => sub {
        my ($file, $suffix) = @_;
        return ('script_name', undef, '.pl');
    };

    my $self = bless { opt => { searchpath => [] } }, 'XML::Simple';
    my $result = eval { XML::Simple::default_config_file($self) };
    if ($@) {
        fail('Function crashed: ' . $@);
    } else {
        is($result, 'script_name.xml', 'default_config_file returns correct file name when script_dir is undef');
        is_deeply($self->{opt}->{searchpath}, [], 'searchpath is not updated when script_dir is undef');
    }
}

# Test case: Script name with special characters
{
    mock 'File::Basename', fileparse => sub {
        my ($file, $suffix) = @_;
        return ('script@name', '/path/to/script', '.pl');
    };

    my $self = bless { opt => { searchpath => [] } }, 'XML::Simple';
    my $result = eval { XML::Simple::default_config_file($self) };
    if ($@) {
        fail('Function crashed: ' . $@);
    } else {
        is($result, 'script@name.xml', 'default_config_file handles special characters in script name');
        is_deeply($self->{opt}->{searchpath}, ['/path/to/script'], 'searchpath is updated correctly with special characters');
    }
}

done_testing();
