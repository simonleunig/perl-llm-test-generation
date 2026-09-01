use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::parse_string"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'parse_string is defined'); }

# Test case 1: Valid XML string
my $xml_string = '<root><person><name>John</name><age>30</age></person></root>';
my $result = eval { XML::Simple::parse_string($xml_string) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for valid XML string'); }

# Test case 2: Invalid XML string
$xml_string = '<root><person><name>John</name><age>30</age>';
$result = eval { XML::Simple::parse_string($xml_string) };
if ($@) { ok(1, 'Function crashes for invalid XML string'); } else { fail('Function did not crash for invalid XML string'); }

# Test case 3: Empty XML string
$xml_string = '';
$result = eval { XML::Simple::parse_string($xml_string) };
if ($@) { ok(1, 'Function crashes for empty XML string'); } else { fail('Function did not crash for empty XML string'); }

# Test case 4: XML string with options
$xml_string = '<root><person><name>John</name><age>30</age></person></root>';
my $options = { ForceArray => 1 };
$result = eval { XML::Simple::parse_string($xml_string, %$options) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for XML string with options'); }

done_testing();
