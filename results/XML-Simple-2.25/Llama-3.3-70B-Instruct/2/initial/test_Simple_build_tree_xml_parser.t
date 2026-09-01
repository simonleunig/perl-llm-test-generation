use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::build_tree_xml_parser"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'build_tree_xml_parser is defined'); }

# Test case 1: XML::Parser is not installed
my $mock = mock 'XML::Simple' => (
    track => {
        new_xml_parser => sub { die 'XML::Parser is not installed' },
    },
);
my $result = eval { XML::Simple->build_tree_xml_parser('filename', 'string') };
if ($@) { like($@, qr/XMLin\(\) requires either XML::SAX or XML::Parser/, 'build_tree_xml_parser crashes when XML::Parser is not installed'); } else { fail('build_tree_xml_parser did not crash when XML::Parser is not installed'); }

# Test case 2: nsexpand option is set
$mock = mock 'XML::Simple' => (
    track => {
        new_xml_parser => sub { bless {}, 'XML::Parser' },
    },
);
my $simple = bless { opt => { nsexpand => 1 } }, 'XML::Simple';
$result = eval { $simple->build_tree_xml_parser('filename', 'string') };
if ($@) { fail('build_tree_xml_parser crashed when nsexpand option is set: ' . $@); } else { ok(1, 'build_tree_xml_parser does not crash when nsexpand option is set'); }

# Test case 3: XML data is malformed
$mock = mock 'XML::Parser' => (
    track => {
        parse => sub { die 'Malformed XML data' },
    },
);
$mock = mock 'XML::Simple' => (
    track => {
        new_xml_parser => sub { bless {}, 'XML::Parser' },
    },
);
$simple = bless { opt => {} }, 'XML::Simple';
$result = eval { $simple->build_tree_xml_parser('filename', 'string') };
if ($@) { like($@, qr/Malformed XML data/, 'build_tree_xml_parser crashes when XML data is malformed'); } else { fail('build_tree_xml_parser did not crash when XML data is malformed'); }

# Test case 4: Normal successful operation
$mock = mock 'XML::Parser' => (
    track => {
        parse => sub { return 'Parsed XML data' },
    },
);
$mock = mock 'XML::Simple' => (
    track => {
        new_xml_parser => sub { bless {}, 'XML::Parser' },
    },
);
$simple = bless { opt => {} }, 'XML::Simple';
$result = eval { $simple->build_tree_xml_parser('filename', 'string') };
if ($@) { fail('build_tree_xml_parser crashed during normal operation: ' . $@); } else { is($result, 'Parsed XML data', 'build_tree_xml_parser returns parsed XML data during normal operation'); }

done_testing();
