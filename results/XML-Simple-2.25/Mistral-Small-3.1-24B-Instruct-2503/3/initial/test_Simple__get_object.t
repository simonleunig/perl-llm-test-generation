use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }  # Use actual module name from package declaration

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::_get_object"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, '_get_object is defined'); }

# Mocking XML::Simple->new
mock 'XML::Simple' => (
    override => [
        new => sub {
            return bless {}, 'XML::Simple';
        }
    ]
);

# Test case 1: Passing an XML::Simple object
my $xml_simple_obj = bless {}, 'XML::Simple';
my $result = eval { XML::Simple::_get_object($xml_simple_obj) };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, $xml_simple_obj, 'Passing an XML::Simple object returns the same object');
}

# Test case 2: Passing undef
$result = eval { XML::Simple::_get_object(undef) };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(UNIVERSAL::isa($result, 'XML::Simple'), 'Passing undef creates a new XML::Simple object');
}

# Test case 3: Passing a non-XML::Simple object
my $non_xml_simple_obj = bless {}, 'NonXML::Simple';
$result = eval { XML::Simple::_get_object($non_xml_simple_obj) };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(UNIVERSAL::isa($result, 'XML::Simple'), 'Passing a non-XML::Simple object creates a new XML::Simple object');
}

# Test case 4: Passing no arguments
$result = eval { XML::Simple::_get_object() };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(UNIVERSAL::isa($result, 'XML::Simple'), 'Passing no arguments creates a new XML::Simple object');
}

done_testing();
