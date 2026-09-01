use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::build_tree_xml_parser"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'build_tree_xml_parser is defined'); }

my ($fh, $filename) = tempfile();
print $fh '<root><person><name>John</name></person></root>';
close $fh;
my $simple = bless {}, 'XML::Simple';
my $result = eval { $simple->build_tree_xml_parser($filename) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result from file'); }
unlink $filename;

my $xml_string = '<root><person><name>John</name></person></root>';
$result = eval { $simple->build_tree_xml_parser(undef, \$xml_string) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result from string'); }

my $mock;
eval { require XML::Parser; };
if ($@) {
    # DEPENDENCY MISSING: XML::Parser - mock skipped
} else {
    no strict 'refs';
    if (defined &{"XML::Parser::new"}) {
        $mock = mock 'XML::Simple' => ( override => [ new_xml_parser => sub { die 'XML::Parser not found' } ] );
    } else {
        $mock = mock 'XML::Simple' => ( add => [ new_xml_parser => sub { die 'XML::Parser not found' } ] );
    }
}
$simple = bless {}, 'XML::Simple';
$result = eval { $simple->build_tree_xml_parser($filename) };
if ($@) { ok($@ =~ /XMLin\(\) requires either XML::SAX or XML::Parser/, 'Function croaks without XML::Parser'); } else { fail('Function did not croak without XML::Parser'); }

$mock = mock 'XML::Simple' => ( override => [ new_xml_parser => sub { bless {}, 'XML::Parser' } ] );
$simple = bless { opt => { nsexpand => 1 } }, 'XML::Simple';
$result = eval { $simple->build_tree_xml_parser($filename) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result with nsexpand option'); }

done_testing();