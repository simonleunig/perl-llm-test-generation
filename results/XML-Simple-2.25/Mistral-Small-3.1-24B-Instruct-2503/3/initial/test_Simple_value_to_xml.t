use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }  # Use actual module name from package declaration

# Mock dependencies
mock 'Scalar::Util' => ( refaddr => sub { return 1; } );
mock 'UNIVERSAL' => ( isa => sub { return 1; } );
mock 'XML::NamespaceSupport' => (
    new => sub { return bless {}, 'XML::NamespaceSupport' },
    push_context => sub { return 1; },
    pop_context => sub { return 1; },
    declare_prefix => sub { return 1; },
    get_uri => sub { return 'http://example.com'; },
    get_prefix => sub { return 'ns'; },
    parse_jclark_notation => sub { return ('http://example.com', 'element'); }
);
mock 'Carp' => ( croak => sub { die shift; }, carp => sub { warn shift; } );

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::value_to_xml"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'value_to_xml is defined'); }

# Test cases with eval protection

# Test with a simple hash reference
my $simple_hash = { key => 'value' };
my $result = eval { XML::Simple::value_to_xml({}, $simple_hash, 'root') };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, "<root>\n<key>value</key>\n</root>\n", 'Simple hash reference converted to XML');
}

# Test with a hash reference containing nested hashes
my $nested_hash = { key => { nested_key => 'nested_value' } };
$result = eval { XML::Simple::value_to_xml({}, $nested_hash, 'root') };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, "<root>\n<key>\n<nested_key>nested_value</nested_key>\n</key>\n</root>\n", 'Nested hash reference converted to XML');
}

# Test with an array reference
my $array_ref = [ 'value1', 'value2' ];
$result = eval { XML::Simple::value_to_xml({}, $array_ref, 'root') };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, "<root>\n<root>value1</root>\n<root>value2</root>\n</root>\n", 'Array reference converted to XML');
}

# Test with circular data structure (should croak)
my $circular_ref;
$circular_ref = { key => $circular_ref };
$result = eval { XML::Simple::value_to_xml({}, $circular_ref, 'root') };
if ($@) {
    like($@, qr/circular data structures not supported/, 'Circular data structure detected');
} else {
    fail('Function did not croak on circular data structure');
}

# Test with undefined values
my $undefined_hash = { key => undef };
$result = eval { XML::Simple::value_to_xml({}, $undefined_hash, 'root') };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, "<root>\n<key></key>\n</root>\n", 'Undefined value handled correctly');
}

# Test with namespaces
my $namespace_hash = { 'xmlns' => 'http://example.com', 'ns:key' => 'value' };
$result = eval { XML::Simple::value_to_xml({}, $namespace_hash, 'root') };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, "<root xmlns=\"http://example.com\" xmlns:ns=\"http://example.com\">\n<ns:key>value</ns:key>\n</root>\n", 'Namespaces handled correctly');
}

# Test with attributes
my $attr_hash = { key => { attr => 'value' } };
$result = eval { XML::Simple::value_to_xml({}, $attr_hash, 'root', { valueattr => { key => 'attr' } }) };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, "<root>\n<key attr=\"value\"/>\n</root>\n", 'Attributes handled correctly');
}

done_testing();
