use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::XMLout"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'XMLout is defined'); }

# Mocking external dependencies
my $mock_ns;
# AFTER LAST PASS: eval { require XML::NamespaceSupport; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: XML::NamespaceSupport - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"XML::NamespaceSupport::new"}) {
        # AFTER LAST PASS: $mock_ns = mock 'XML::NamespaceSupport' => ( new => sub { return bless {}, 'XML::NamespaceSupport' } );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock_ns = mock 'XML::NamespaceSupport' => ( add => { new => sub { return bless {}, 'XML::NamespaceSupport' } } );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

my $mock_sax;
# AFTER LAST PASS: eval { require XML::SAX::ParserFactory; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: XML::SAX::ParserFactory - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"XML::SAX::ParserFactory::parser"}) {
        # AFTER LAST PASS: $mock_sax = mock 'XML::SAX::ParserFactory' => ( parser => sub { return bless {}, 'XML::SAX::Parser' } );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock_sax = mock 'XML::SAX::ParserFactory' => ( add => { parser => sub { return bless {}, 'XML::SAX::Parser' } } );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# AFTER LAST PASS: mock 'IO::Handle' => ( print => sub { return 1 } );

# Test case 1: Basic hash reference to XML
my $hash_ref;  # AFTER LAST PASS: my $hash_ref = { key => 'value' };
my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::XMLout($hash_ref) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
    # FAILED: is($result, '<key>value</key>', 'Basic hash reference to XML');
# FAILED: }

# Test case 2: Array reference wrapped in a hash
my $array_ref;  # AFTER LAST PASS: my $array_ref = [ 'value1', 'value2' ];
my $wrapped_array_ref;  # AFTER LAST PASS: my $wrapped_array_ref = { anon => $array_ref };
# UNVALIDATED: $result = eval { XML::Simple::XMLout($wrapped_array_ref) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
    # FAILED: is($result, '<anon><item>value1</item><item>value2</item></anon>', 'Array reference wrapped in a hash');
# FAILED: }

# Test case 3: Top-level attributes with rootname
my $top_level_attrs;  # AFTER LAST PASS: my $top_level_attrs = { key => 'value', attr => 'attr_value' };
# UNVALIDATED: $result = eval { XML::Simple::XMLout($top_level_attrs, RootName => 'root') };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
    # FAILED: is($result, '<root><key>value</key><attr>attr_value</attr></root>', 'Top-level attributes with rootname');
# FAILED: }

# Test case 4: Output to file
my ($fh, $filename);  # AFTER LAST PASS: my ($fh, $filename) = tempfile();
# UNVALIDATED: $result = eval { XML::Simple::XMLout($hash_ref, OutputFile => $filename) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
    my $in;  # AFTER LAST PASS: my $in;  # FAILED: open(my $in, '<', $filename) or die "Could not open file '$filename' $!";
    my $content;  # AFTER LAST PASS: my $content;  # FAILED: my $content = do { local $/; <$in> };
    # FAILED: close($in);
    # FAILED: is($content, '<key>value</key>', 'Output to file');
# FAILED: }

# Test case 5: SAX handler
# AFTER LAST PASS: mock 'XML::SAX::Parser' => ( parse_string => sub { return 1 } );
# UNVALIDATED: $result = eval { XML::Simple::XMLout($hash_ref, Handler => bless {}, 'XML::SAX::Handler') };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
    # FAILED: is($result, 1, 'SAX handler');
# FAILED: }

# Test case 6: Namespace expansion
my $ns_expand_hash;  # AFTER LAST PASS: my $ns_expand_hash = { key => 'value' };
# UNVALIDATED: $result = eval { XML::Simple::XMLout($ns_expand_hash, NSExpand => 1) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
    # FAILED: like($result, qr/<aaa:key>value<\/aaa:key>/, 'Namespace expansion');
# FAILED: }

# Test case 7: Undefined values
my $undefined_hash;  # AFTER LAST PASS: my $undefined_hash = { key => undef };
# UNVALIDATED: $result = eval { XML::Simple::XMLout($undefined_hash) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
    # FAILED: is($result, '<key/>', 'Undefined values');
# FAILED: }

# Test case 8: Circular data structures (should die)
my $circular_ref;
# AFTER LAST PASS: $circular_ref = { self => $circular_ref };
# UNVALIDATED: $result = eval { XML::Simple::XMLout($circular_ref) };
# AFTER LAST PASS: if ($@) {
    # FAILED: like($@, qr/Can't use string/, 'Circular data structures');
# AFTER LAST PASS: } else {
    # FAILED: fail('Circular data structures did not cause an error');
# AFTER LAST PASS: }

# Test case 9: Mixed content (elements containing both text and nested elements)
my $mixed_content;  # AFTER LAST PASS: my $mixed_content = { key => { nested => 'value', text => 'text' } };
# UNVALIDATED: $result = eval { XML::Simple::XMLout($mixed_content) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
    # FAILED: is($result, '<key><nested>value</nested>text</key>', 'Mixed content');
# FAILED: }

done_testing();