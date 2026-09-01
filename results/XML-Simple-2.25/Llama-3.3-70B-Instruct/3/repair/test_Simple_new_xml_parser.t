use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::new_xml_parser"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'new_xml_parser is defined'); }

my $xml_simple = bless {}, 'XML::Simple';
$xml_simple->{opt} = { parseropts => [] };

my $result = eval { XML::Simple::new_xml_parser($xml_simple) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }

my $mock;
eval { require XML::Parser; };
if ($@) {
    # DEPENDENCY MISSING: XML::Parser - mock skipped
} else {
    no strict 'refs';
    if (defined &{"XML::Parser::new"}) {
        $mock = mock 'XML::Parser' => (new => sub { die 'XML::Parser module not installed' });
    } else {
        $mock = mock 'XML::Parser' => (new => sub { die 'XML::Parser module not installed' });
    }
}

my $result2 = eval { XML::Simple::new_xml_parser($xml_simple) };
if ($@) { ok($@ =~ /XML::Parser module not installed/, 'Error handling - XML::Parser module not installed'); } else { fail('Expected error not thrown'); }

$xml_simple->{opt} = { parseropts => ['InvalidOption'] };
my $result3 = eval { XML::Simple::new_xml_parser($xml_simple) };
if ($@) { ok($@, 'Error handling - Invalid options'); } else { fail('Expected error not thrown'); }

done_testing();