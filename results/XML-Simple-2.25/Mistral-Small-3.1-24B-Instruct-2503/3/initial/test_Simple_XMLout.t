use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }  # Use actual module name from package declaration

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::XMLout"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'XMLout is defined'); }

# Mocking external dependencies
mock 'XML::NamespaceSupport' => ( new => sub { return bless {}, 'XML::NamespaceSupport' } );
mock 'XML::SAX::ParserFactory' => ( parser => sub { return bless {}, 'XML::SAX::Parser' } );
mock 'IO::Handle' => ( print => sub { return 1 } );

# Test case 1: Basic hash reference to XML
my $hash_ref = { key => 'value' };
my $result = eval { XML::Simple::XMLout($hash_ref) };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, '<key>value</key>', 'Basic hash reference to XML');
}

# Test case 2: Array reference wrapped in a hash
my $array_ref = [ 'value1', 'value2' ];
my $wrapped_array_ref = { anon => $array_ref };
$result = eval { XML::Simple::XMLout($wrapped_array_ref) };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, '<anon><item>value1</item><item>value2</item></anon>', 'Array reference wrapped in a hash');
}

# Test case 3: Top-level attributes with rootname
my $top_level_attrs = { key => 'value', attr => 'attr_value' };
$result = eval { XML::Simple::XMLout($top_level_attrs, RootName => 'root') };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, '<root><key>value</key><attr>attr_value</attr></root>', 'Top-level attributes with rootname');
}

# Test case 4: Output to file
my ($fh, $filename) = tempfile();
$result = eval { XML::Simple::XMLout($hash_ref, OutputFile => $filename) };
if ($@) { fail('Function crashed: ' . $@); } else {
    open(my $in, '<', $filename) or die "Could not open file '$filename' $!";
    my $content = do { local $/; <$in> };
    close($in);
    is($content, '<key>value</key>', 'Output to file');
}

# Test case 5: SAX handler
my $sax_handler = bless {}, 'XML::SAX::Base';
$result = eval { XML::Simple::XMLout($hash_ref, Handler => $sax_handler) };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok($result, 'SAX handler');
}

# Test case 6: Namespace expansion
my $ns_expand_hash = { key => 'value' };
$result = eval { XML::Simple::XMLout($ns_expand_hash, NSExpand => 1) };
if ($@) { fail('Function crashed: ' . $@); } else {
    like($result, qr/<aaa:key>value<\/aaa:key>/, 'Namespace expansion');
}

# Test case 7: Undefined values
my $undefined_hash = { key => undef };
$result = eval { XML::Simple::XMLout($undefined_hash) };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, '<key/>', 'Undefined values');
}

# Test case 8: Circular data structures (should die)
my $circular_ref;
$circular_ref = { self => $circular_ref };
$result = eval { XML::Simple::XMLout($circular_ref) };
if ($@) {
    like($@, qr/circular reference/, 'Circular data structures');
} else {
    fail('Circular data structures did not cause an error');
}

# Test case 9: Mixed content (elements containing both text and nested elements)
my $mixed_content = { key => { nested => 'value', text => 'text' } };
$result = eval { XML::Simple::XMLout($mixed_content) };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, '<key><nested>value</nested>text</key>', 'Mixed content');
}

# Test case 10: Non-scalar key attributes
my $non_scalar_key = { 'key1' => 'value1', 'key2' => 'value2' };
$result = eval { XML::Simple::XMLout($non_scalar_key) };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, '<key1>value1</key1><key2>value2</key2>', 'Non-scalar key attributes');
}

done_testing();
