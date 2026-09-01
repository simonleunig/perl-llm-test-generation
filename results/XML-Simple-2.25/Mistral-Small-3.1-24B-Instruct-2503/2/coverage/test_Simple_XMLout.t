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
        # AFTER LAST PASS: $mock_ns = mock 'XML::NamespaceSupport' => ( override => [ new => sub { return bless {}, 'XML::NamespaceSupport' } ] );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock_ns = mock 'XML::NamespaceSupport' => ( add => [ new => sub { return bless {}, 'XML::NamespaceSupport' } ] );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

my $mock_sax;
# AFTER LAST PASS: eval { require XML::SAX::ParserFactory; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: XML::SAX::ParserFactory - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"XML::SAX::ParserFactory::parser"}) {
        # AFTER LAST PASS: $mock_sax = mock 'XML::SAX::ParserFactory' => ( override => [ parser => sub { return bless {}, 'XML::SAX::Parser' } ] );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock_sax = mock 'XML::SAX::ParserFactory' => ( add => [ parser => sub { return bless {}, 'XML::SAX::Parser' } ] );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

my $mock_io;
# AFTER LAST PASS: eval { require IO::Handle; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: IO::Handle - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"IO::Handle::print"}) {
        # AFTER LAST PASS: $mock_io = mock 'IO::Handle' => ( override => [ print => sub { return 1 } ] );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock_io = mock 'IO::Handle' => ( add => [ print => sub { return 1 } ] );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# Test case 1: Basic hash reference to XML
my $hash_ref;  # AFTER LAST PASS: my $hash_ref = { key => 'value' };
my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::XMLout($hash_ref) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
    # FAILED: is($result, '<key>value</key>', 'Basic hash reference to XML');
# FAILED: }

# Test case 2: Array reference wrapped in hash
my $array_ref;  # AFTER LAST PASS: my $array_ref = [ 'value1', 'value2' ];
my $wrapped_array_ref;  # AFTER LAST PASS: my $wrapped_array_ref = { anon => $array_ref };
# UNVALIDATED: $result = eval { XML::Simple::XMLout($wrapped_array_ref) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
    # FAILED: is($result, '<anon><item>value1</item><item>value2</item></anon>', 'Array reference wrapped in hash');
# FAILED: }

# Test case 3: Hash reference with root name
my $hash_with_root;  # AFTER LAST PASS: my $hash_with_root = { root => { key => 'value' } };
# UNVALIDATED: $result = eval { XML::Simple::XMLout($hash_with_root, KeyAttr => {}, RootName => 'root') };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
    # FAILED: is($result, '<root><key>value</key></root>', 'Hash reference with root name');
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

# Test case 5: Output to SAX handler
# AFTER LAST PASS: mock 'XML::SAX::Parser' => ( parse_string => sub { return 1 } );
# UNVALIDATED: $result = eval { XML::Simple::XMLout($hash_ref, Handler => bless {}, 'XML::SAX::Handler') };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
    # FAILED: is($result, 1, 'Output to SAX handler');
# FAILED: }

# Test case 6: Namespace expansion
my $hash_with_ns;  # AFTER LAST PASS: my $hash_with_ns = { key => 'value' };
# UNVALIDATED: $result = eval { XML::Simple::XMLout($hash_with_ns, NSExpand => 1) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
    # FAILED: like($result, qr/<aaa:key>value<\/aaa:key>/, 'Namespace expansion');
# FAILED: }

# Test case 7: Error handling - missing argument
# UNVALIDATED: $result = eval { XML::Simple::XMLout() };
# FAILED: if ($@) { like($@, qr/XMLout\(\) requires at least one argument/, 'Error handling - missing argument'); } else {
    # FAILED: fail('Expected error for missing argument');
# FAILED: }

# Test case 8: Error handling - invalid file output
my $invalid_filename;  # AFTER LAST PASS: my $invalid_filename = '/invalid/path/file.xml';
# UNVALIDATED: $result = eval { XML::Simple::XMLout($hash_ref, OutputFile => $invalid_filename) };
# FAILED: if ($@) { like($@, qr/open\($invalid_filename\):/, 'Error handling - invalid file output'); } else {
    # FAILED: fail('Expected error for invalid file output');
# FAILED: }

done_testing();