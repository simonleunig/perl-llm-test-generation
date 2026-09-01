use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw(mock unmock);
use File::Temp qw(tempfile tempdir);
use File::Spec;
use IO::Handle;
use Scalar::Util qw(blessed);
use Carp;

# Load the module
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::parse_fh"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'parse_fh is defined'); }

# Mock dependencies
my $mock;
eval { require XML::Simple; };
if ($@) {
    # DEPENDENCY MISSING: XML::Simple - mock skipped
} else {
    no strict 'refs';
    if (defined &{"XML::Simple::_get_object"}) {
        $mock = mock 'XML::Simple' => (
            override => [
                _get_object => sub { bless {}, 'XML::Simple' },
                handle_options => sub { return 1; },
                build_simple_tree => sub { return { parsed => 'data' }; },
            ]
        );
    } else {
        $mock = mock 'XML::Simple' => (
            add => [
                _get_object => sub { bless {}, 'XML::Simple' },
                handle_options => sub { return 1; },
                build_simple_tree => sub { return { parsed => 'data' }; },
            ]
        );
    }
}

# Test case: Valid filehandle
{
    my ($fh, $filename) = tempfile();
    print $fh '<root><child>data</child></root>';
    seek $fh, 0, 0;

    my $result = eval { XML::Simple::parse_fh($fh) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is(blessed($result), 'HASH', 'Function returns a hash reference');
        is($result->{parsed}, 'data', 'Parsed data is correct');
    }
}

# Test case: Invalid filehandle (string)
{
    my $result = eval { XML::Simple::parse_fh('not_a_filehandle') };
    if ($@) {
        like($@, qr/Can't use string/, 'Function throws error for string input');
    } else {
        fail('Function did not throw error for string input');
    }
}

# Test case: Invalid filehandle (undef)
{
    my $result = eval { XML::Simple::parse_fh(undef) };
    if ($@) {
        like($@, qr/Can't use undef/, 'Function throws error for undef input');
    } else {
        fail('Function did not throw error for undef input');
    }
}

# Test case: Invalid filehandle (non-filehandle object)
{
    my $result = eval { XML::Simple::parse_fh({}) };
    if ($@) {
        like($@, qr/Can't use HASH/, 'Function throws error for non-filehandle object');
    } else {
        fail('Function did not throw error for non-filehandle object');
    }
}

# Clean up mocks
unmock 'XML::Simple';

done_testing();