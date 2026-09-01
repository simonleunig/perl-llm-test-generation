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
eval { require XML::NamespaceSupport; };
if ($@) {
    # DEPENDENCY MISSING: XML::NamespaceSupport - mock skipped
} else {
    no strict 'refs';
    if (defined &{"XML::NamespaceSupport::new"}) {
        $mock_ns = mock 'XML::NamespaceSupport' => ( override => [ new => sub { return bless {}, 'XML::NamespaceSupport' } ] );
    } else {
        $mock_ns = mock 'XML::NamespaceSupport' => ( add => [ new => sub { return bless {}, 'XML::NamespaceSupport' } ] );
    }
}

my $mock_sax;
eval { require XML::SAX::ParserFactory; };
if ($@) {
    # DEPENDENCY MISSING: XML::SAX::ParserFactory - mock skipped
} else {
    no strict 'refs';
    if (defined &{"XML::SAX::ParserFactory::parser"}) {
        $mock_sax = mock 'XML::SAX::ParserFactory' => ( override => [ parser => sub { return bless {}, 'XML::SAX::Parser' } ] );
    } else {
        $mock_sax = mock 'XML::SAX::ParserFactory' => ( add => [ parser => sub { return bless {}, 'XML::SAX::Parser' } ] );
    }
}

my $mock_io;
eval { require IO::Handle; };
if ($@) {
    # DEPENDENCY MISSING: IO::Handle - mock skipped
} else {
    no strict 'refs';
    if (defined &{"IO::Handle::print"}) {
        $mock_io = mock 'IO::Handle' => ( override => [ print => sub { return 1 } ] );
    } else {
        $mock_io = mock 'IO::Handle' => ( add => [ print => sub { return 1 } ] );
    }
}

# Test case 1: Basic hash reference to XML
my $hash_ref = { key => 'value' };
my $result = eval { XML::Simple::XMLout($hash_ref) };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, '<key>value</key>', 'Basic hash reference to XML');
}

# Test case 2: Array reference wrapped in hash
my $array_ref = [ 'value1', 'value2' ];
my $wrapped_array_ref = { anon => $array_ref };
$result = eval { XML::Simple::XMLout($wrapped_array_ref) };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, '<anon><item>value1</item><item>value2</item></anon>', 'Array reference wrapped in hash');
}

# Test case 3: Hash reference with root name
my $hash_with_root = { root => { key => 'value' } };
$result = eval { XML::Simple::XMLout($hash_with_root, KeyAttr => {}, RootName => 'root') };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, '<root><key>value</key></root>', 'Hash reference with root name');
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

# Test case 5: Output to SAX handler
mock 'XML::SAX::Parser' => ( parse_string => sub { return 1 } );
$result = eval { XML::Simple::XMLout($hash_ref, Handler => bless {}, 'XML::SAX::Handler') };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, 1, 'Output to SAX handler');
}

# Test case 6: Namespace expansion
my $hash_with_ns = { key => 'value' };
$result = eval { XML::Simple::XMLout($hash_with_ns, NSExpand => 1) };
if ($@) { fail('Function crashed: ' . $@); } else {
    like($result, qr/<aaa:key>value<\/aaa:key>/, 'Namespace expansion');
}

# Test case 7: Error handling - missing argument
$result = eval { XML::Simple::XMLout() };
if ($@) { like($@, qr/XMLout\(\) requires at least one argument/, 'Error handling - missing argument'); } else {
    fail('Expected error for missing argument');
}

# Test case 8: Error handling - invalid file output
my $invalid_filename = '/invalid/path/file.xml';
$result = eval { XML::Simple::XMLout($hash_ref, OutputFile => $invalid_filename) };
if ($@) { like($@, qr/open\($invalid_filename\):/, 'Error handling - invalid file output'); } else {
    fail('Expected error for invalid file output');
}

done_testing();