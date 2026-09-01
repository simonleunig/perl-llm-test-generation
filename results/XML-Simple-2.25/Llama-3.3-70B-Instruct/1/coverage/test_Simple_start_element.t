use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::start_element"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'start_element is defined'); }

# Test case 1: Normal operation with nsexpand option disabled
my $xml_simple = bless { opt => { nsexpand => 0 }, lists => [], curlist => [] }, 'XML::Simple';
my $element = { Name => 'test', LocalName => 'test', NamespaceURI => 'http://example.com', Attributes => { attr1 => { Name => 'attr1', Value => 'value1' } } };
my $result = eval { $xml_simple->start_element($element) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }

# Test case 2: Normal operation with nsexpand option enabled
$xml_simple = bless { opt => { nsexpand => 1 }, lists => [], curlist => [] }, 'XML::Simple';
$element = { Name => 'test', LocalName => 'test', NamespaceURI => 'http://example.com', Attributes => { attr1 => { Name => 'attr1', LocalName => 'attr1', NamespaceURI => 'http://example.com', Value => 'value1' } } };
$result = eval { $xml_simple->start_element($element) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }

# Test case 3: Edge case with empty Attributes
$xml_simple = bless { opt => { nsexpand => 0 }, lists => [], curlist => [] }, 'XML::Simple';
$element = { Name => 'test', LocalName => 'test', NamespaceURI => 'http://example.com', Attributes => {} };
$result = eval { $xml_simple->start_element($element) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }

# Test case 4: Edge case with undefined Attributes
$xml_simple = bless { opt => { nsexpand => 0 }, lists => [], curlist => [] }, 'XML::Simple';
$element = { Name => 'test', LocalName => 'test', NamespaceURI => 'http://example.com' };
$result = eval { $xml_simple->start_element($element) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }

done_testing();
