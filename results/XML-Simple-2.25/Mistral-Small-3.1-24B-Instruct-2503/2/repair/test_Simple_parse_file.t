use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::parse_file"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'parse_file is defined'); }

# Mock dependencies
my $mock;
eval { require XML::Simple; };
if ($@) {
    # DEPENDENCY MISSING: XML::Simple - mock skipped
} else {
    no strict 'refs';
    if (defined &{"XML::Simple::handle_options"}) {
        $mock = mock 'XML::Simple' => (
            override => [
                handle_options => sub { return 1; },
                default_config_file => sub { return 'default.xml'; },
                find_xml_file => sub { return shift; },
                build_simple_tree => sub { return { parsed => 'data' }; },
                cache_read_ => sub { return undef; },
                cache_write_ => sub { return 1; },
            ]
        );
    } else {
        $mock = mock 'XML::Simple' => (
            add => [
                handle_options => sub { return 1; },
                default_config_file => sub { return 'default.xml'; },
                find_xml_file => sub { return shift; },
                build_simple_tree => sub { return { parsed => 'data' }; },
                cache_read_ => sub { return undef; },
                cache_write_ => sub { return 1; },
            ]
        );
    }
}

# Test case: Normal operation with valid XML file
{
    my ($fh, $filename) = tempfile();
    print $fh '<root><child>data</child></root>';
    close $fh;

    my $result = eval { XML::Simple::parse_file($filename) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is(ref($result), 'HASH', 'parse_file returns a hash reference');
        is($result->{parsed}, 'data', 'Parsed data is correct');
    }
}

# Test case: File not found
{
    my $result = eval { XML::Simple::parse_file('nonexistent.xml') };
    if ($@) { like($@, qr/No such file or directory/, 'File not found error is thrown'); } else {
        fail('Expected file not found error, but function did not crash');
    }
}

# Test case: Empty XML file
{
    my ($fh, $filename) = tempfile();
    close $fh;

    my $result = eval { XML::Simple::parse_file($filename) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is(ref($result), 'HASH', 'parse_file returns a hash reference');
        is_deeply($result, {}, 'Empty file returns an empty hash reference');
    }
}

# Test case: Invalid XML file
{
    my ($fh, $filename) = tempfile();
    print $fh '<root><child>data';
    close $fh;

    my $result = eval { XML::Simple::parse_file($filename) };
    if ($@) { like($@, qr/Unexpected end of document/, 'Invalid XML error is thrown'); } else {
        fail('Expected invalid XML error, but function did not crash');
    }
}

# Test case: Caching enabled
{
    mock 'XML::Simple' => (
        override => [
            cache_read_ => sub { return { cached => 'data' }; },
        ]
    );

    my ($fh, $filename) = tempfile();
    print $fh '<root><child>data</child></root>';
    close $fh;

    my $result = eval { XML::Simple::parse_file($filename) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is(ref($result), 'HASH', 'parse_file returns a hash reference');
        is($result->{cached}, 'data', 'Cached data is returned');
    }
}

done_testing();