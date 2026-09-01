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

my $result = eval { XML::Simple->new()->build_tree_xml_parser('filename.xml', undef); };
if ($@) { like($@, qr/XMLin\(\) requires either XML::SAX or XML::Parser/, 'build_tree_xml_parser crashes without XML::Parser'); } else { fail('build_tree_xml_parser did not crash without XML::Parser'); }

my $simple = bless { opt => { nsexpand => 1 } }, 'XML::Simple';
$result = eval { $simple->build_tree_xml_parser('filename.xml', undef); };
if ($@) { fail('build_tree_xml_parser crashed with nsexpand option: ' . $@); } else { ok(1, 'build_tree_xml_parser did not crash with nsexpand option'); }

my ($fh, $filename) = tempfile();
print $fh '<root><person><name>John</name></person></root>';
close $fh;
$simple = bless { opt => {} }, 'XML::Simple';
my $mock;
eval { require XML::Parser; };
if ($@) {
    # DEPENDENCY MISSING: XML::Parser - mock skipped
} else {
    no strict 'refs';
    if (defined &{"XML::Parser::new"}) {
        $mock = mock 'XML::Parser' => ( override => [ new => sub { bless { parse => sub { { root => { person => { name => 'John' } } } } }, 'XML::Parser' ] );
    } else {
        $mock = mock 'XML::Parser' => ( add => [ new => sub { bless { parse => sub { { root => { person => { name => 'John' } } } } }, 'XML::Parser' ] );
    }
}
$result = eval { $simple->build_tree_xml_parser($filename, undef); };
if ($@) { fail('build_tree_xml_parser crashed parsing from file: ' . $@); } else { is_deeply($result, { root => { person => { name => 'John' } } }, 'build_tree_xml_parser parsed XML from file correctly'); }

$simple = bless { opt => {} }, 'XML::Simple';
$mock = undef;
eval { require XML::Parser; };
if ($@) {
    # DEPENDENCY MISSING: XML::Parser - mock skipped
} else {
    no strict 'refs';
    if (defined &{"XML::Parser::new"}) {
        $mock = mock 'XML::Parser' => ( override => [ new => sub { bless { parse => sub { { root => { person => { name => 'John' } } } } }, 'XML::Parser' ] );
    } else {
        $mock = mock 'XML::Parser' => ( add => [ new => sub { bless { parse => sub { { root => { person => { name => 'John' } } } } }, 'XML::Parser' ] );
    }
}
$result = eval { $simple->build_tree_xml_parser(undef, '<root><person><name>John</name></person></root>'); };
if ($@) { fail('build_tree_xml_parser crashed parsing from string: ' . $@); } else { is_deeply($result, { root => { person => { name => 'John' } } }, 'build_tree_xml_parser parsed XML from string correctly'); }

done_testing();