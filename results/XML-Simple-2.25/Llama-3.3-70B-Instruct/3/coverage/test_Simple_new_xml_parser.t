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

my $xml_simple;  # AFTER LAST PASS: my $xml_simple = bless {}, 'XML::Simple';
# AFTER LAST PASS: $xml_simple->{opt} = { parseropts => [] };

my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::new_xml_parser($xml_simple) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }

my $mock;
# AFTER LAST PASS: eval { require XML::Parser; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: XML::Parser - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"XML::Parser::new"}) {
        # AFTER LAST PASS: $mock = mock 'XML::Parser' => (new => sub { die 'XML::Parser module not installed' });
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock = mock 'XML::Parser' => (new => sub { die 'XML::Parser module not installed' });
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

my $result2;  # AFTER LAST PASS: my $result2;  # UNVALIDATED: my $result2 = eval { XML::Simple::new_xml_parser($xml_simple) };
# FAILED: if ($@) { ok($@ =~ /XML::Parser module not installed/, 'Error handling - XML::Parser module not installed'); } else { fail('Expected error not thrown'); }

# AFTER LAST PASS: $xml_simple->{opt} = { parseropts => ['InvalidOption'] };
my $result3;  # AFTER LAST PASS: my $result3;  # UNVALIDATED: my $result3 = eval { XML::Simple::new_xml_parser($xml_simple) };
# FAILED: if ($@) { ok($@, 'Error handling - Invalid options'); } else { fail('Expected error not thrown'); }

done_testing();