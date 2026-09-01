use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::new_xml_parser"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'new_xml_parser is defined'); }

# Test case 1: Successful creation of XML parser
my $xml_simple = bless {}, 'XML::Simple';
$xml_simple->{opt} = { parseropts => [] };
my $result = eval { XML::Simple::new_xml_parser($xml_simple) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }

# Test case 2: Error handling - XML::Parser module not installed
my $mock = mock 'XML::Parser' => (
    new => sub { die 'XML::Parser module not installed' },
);
my $result2 = eval { XML::Simple::new_xml_parser($xml_simple) };
if ($@) { ok($@ =~ /XML::Parser module not installed/, 'Error handling - XML::Parser module not installed'); } else { fail('Expected error not thrown'); }

# Test case 3: Error handling - Invalid options
$xml_simple->{opt} = { parseropts => ['InvalidOption'] };
my $result3 = eval { XML::Simple::new_xml_parser($xml_simple) };
if ($@) { ok($@, 'Error handling - Invalid options'); } else { fail('Expected error not thrown'); }

done_testing();
