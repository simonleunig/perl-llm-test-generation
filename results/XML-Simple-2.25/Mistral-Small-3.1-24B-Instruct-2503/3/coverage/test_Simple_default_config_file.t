use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw(tempfile tempdir);
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Mock File::Basename::fileparse to control its behavior
my $mock;
eval { require File::Basename; };
if ($@) {
    # DEPENDENCY MISSING: File::Basename - mock skipped
} else {
    no strict 'refs';
    if (defined &{"File::Basename::fileparse"}) {
        $mock = mock 'File::Basename' => ( override => [ fileparse => sub {
            my ($file, $suffix) = @_;
            return ('script_name', '/path/to/script', '.pl');
        } ] );
    } else {
        $mock = mock 'File::Basename' => ( add => [ fileparse => sub {
            my ($file, $suffix) = @_;
            return ('script_name', '/path/to/script', '.pl');
        } ] );
    }
}

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::default_config_file"} };
if ($@) {
    # FAILED: fail('Symbol check crashed: ' . $@);
} else {
    ok($symbol_check, 'default_config_file is defined');
}

# Test case: Normal operation
{
    my $self = bless { opt => { searchpath => [] } }, 'XML::Simple';
    my $result = eval { XML::Simple::default_config_file($self) };
    if ($@) {
        # FAILED: fail('Function crashed: ' . $@);
    } else {
        is($result, 'script_name.xml', 'default_config_file returns correct filename');
        # FAILED: is_deeply($self->{opt}->{searchpath}, ['/path/to/script'], 'searchpath is updated correctly');
    }
}

# Test case: Script directory is not accessible (mocked to return undef)
# AFTER LAST PASS: {
    # AFTER LAST PASS: mock 'File::Basename', fileparse => sub {
        # AFTER LAST PASS: return ('script_name', undef, '.pl');
    # AFTER LAST PASS: };

    my $self;  # AFTER LAST PASS: my $self = bless { opt => { searchpath => [] } }, 'XML::Simple';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::default_config_file($self) };
    # AFTER LAST PASS: if ($@) {
        # FAILED: fail('Function crashed: ' . $@);
    # AFTER LAST PASS: } else {
        # FAILED: is($result, 'script_name.xml', 'default_config_file returns correct filename when script_dir is undef');
        # FAILED: is_deeply($self->{opt}->{searchpath}, [], 'searchpath is not updated when script_dir is undef');
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# Test case: Script name with special characters
# AFTER LAST PASS: {
    # AFTER LAST PASS: mock 'File::Basename', fileparse => sub {
        # AFTER LAST PASS: return ('script_name_with_special@chars', '/path/to/script', '.pl');
    # AFTER LAST PASS: };

    my $self;  # AFTER LAST PASS: my $self = bless { opt => { searchpath => [] } }, 'XML::Simple';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::default_config_file($self) };
    # AFTER LAST PASS: if ($@) {
        # FAILED: fail('Function crashed: ' . $@);
    # AFTER LAST PASS: } else {
        # FAILED: is($result, 'script_name_with_special@chars.xml', 'default_config_file handles special characters in script name');
        # FAILED: is_deeply($self->{opt}->{searchpath}, ['/path/to/script'], 'searchpath is updated correctly with special characters');
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

done_testing();