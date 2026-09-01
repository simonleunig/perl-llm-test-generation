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

# Test case 1: Successful parsing from a file
my ($fh, $filename) = tempfile();
print $fh '<root><person><name>John</name></person></root>';
close $fh;
my $simple = bless {}, 'XML::Simple';
my $result = eval { $simple->build_tree_xml_parser($filename) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result from file'); }
unlink $filename;

# Test case 2: Successful parsing from a string
my $xml_string = '<root><person><name>John</name></person></root>';
$result = eval { $simple->build_tree_xml_parser(undef, $xml_string) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result from string'); }

# Test case 3: Error handling - missing XML::Parser
my $mock = mock 'XML::Simple' => (
    new_xml_parser => sub { die 'XML::Parser not found' },
);
$simple = bless {}, 'XML::Simple';
$result = eval { $simple->build_tree_xml_parser($filename) };
if ($@) { ok($@ =~ /XMLin\(\) requires either XML::SAX or XML::Parser/, 'Function croaks without XML::Parser'); } else { fail('Function did not croak without XML::Parser'); }

# Test case 4: Error handling - nsexpand option
$mock = mock 'XML::Simple' => (
    new_xml_parser => sub { bless {}, 'XML::Parser' },
);
$simple = bless { opt => { nsexpand => 1 } }, 'XML::Simple';
$result = eval { $simple->build_tree_xml_parser($filename) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result with nsexpand option'); }

done_testing();
