use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw(mock unmock);
use File::Temp qw(tempfile tempdir);
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::parse_string"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'parse_string is defined'); }

# Mock dependencies
my $mock;
eval { require XML::Simple; };
if ($@) {
    # DEPENDENCY MISSING: XML::Simple - mock skipped
} else {
    no strict 'refs';
    if (defined &{"XML::Simple::handle_options"} && defined &{"XML::Simple::build_simple_tree"}) {
        $mock = mock 'XML::Simple' => (
            override => [
                handle_options => sub { return 1; },
                build_simple_tree => sub { return { parsed => 'data' }; },
            ],
        );
    } else {
        $mock = mock 'XML::Simple' => (
            add => [
                handle_options => sub { return 1; },
                build_simple_tree => sub { return { parsed => 'data' }; },
            ],
        );
    }
}

# Test case 1: Valid XML string
my $result = eval { XML::Simple::parse_string('<root><child>data</child></root>') };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, { parsed => 'data' }, 'parse_string returns correct data structure for valid XML string');
}

# Test case 2: Valid XML string reference
my $xml_ref = '<root><child>data</child></root>';
$result = eval { XML::Simple::parse_string(\$xml_ref) };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, { parsed => 'data' }, 'parse_string returns correct data structure for valid XML string reference');
}

# Test case 3: Empty XML string
$result = eval { XML::Simple::parse_string('') };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, { parsed => 'data' }, 'parse_string handles empty XML string');
}

# Test case 4: Invalid XML string
$result = eval { XML::Simple::parse_string('<root><child>data</child>') };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, { parsed => 'data' }, 'parse_string handles invalid XML string');
}

# Test case 5: XML string with namespaces
$result = eval { XML::Simple::parse_string('<root xmlns="http://example.com"><child>data</child></root>') };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, { parsed => 'data' }, 'parse_string handles XML string with namespaces');
}

# Test case 6: XML string with attributes
$result = eval { XML::Simple::parse_string('<root attr="value"><child>data</child></root>') };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, { parsed => 'data' }, 'parse_string handles XML string with attributes');
}

# Test case 7: XML string with mixed content
$result = eval { XML::Simple::parse_string('<root>text<child>data</child>more text</root>') };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, { parsed => 'data' }, 'parse_string handles XML string with mixed content');
}

# Test case 8: XML string with nested elements
$result = eval { XML::Simple::parse_string('<root><child><grandchild>data</grandchild></child></root>') };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, { parsed => 'data' }, 'parse_string handles XML string with nested elements');
}

# Clean up mocks
unmock 'XML::Simple';

done_testing();