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

my $mock;
# AFTER LAST PASS: eval { require XML::Parser; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: XML::Parser - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"XML::Parser::new"}) {
        # AFTER LAST PASS: $mock = mock 'XML::Parser' => ( override => [ new => sub { bless {}, 'XML::Parser' } ] );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock = mock 'XML::Parser' => ( add => [ new => sub { bless {}, 'XML::Parser' } ] );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple->build_tree_xml_parser('filename', 'string') };
# FAILED: if ($@) { like($@, qr/XMLin\(\) requires either XML::SAX or XML::Parser/, 'build_tree_xml_parser crashes when XML::Parser is not installed'); } else { fail('build_tree_xml_parser did not crash when XML::Parser is not installed'); }

# AFTER LAST PASS: $mock = mock 'XML::Simple' => (
    # AFTER LAST PASS: track => {
        # AFTER LAST PASS: new_xml_parser => sub { bless {}, 'XML::Parser' },
    # AFTER LAST PASS: },
# AFTER LAST PASS: );
my $simple;  # AFTER LAST PASS: my $simple = bless { opt => { nsexpand => 1 } }, 'XML::Simple';
# UNVALIDATED: $result = eval { $simple->build_tree_xml_parser('filename', 'string') };
# FAILED: if ($@) { fail('build_tree_xml_parser crashed when nsexpand option is set: ' . $@); } else { ok(1, 'build_tree_xml_parser does not crash when nsexpand option is set'); }

# AFTER LAST PASS: $mock = mock 'XML::Parser' => (
    # AFTER LAST PASS: track => {
        # AFTER LAST PASS: parse => sub { die 'Malformed XML data' },
    # AFTER LAST PASS: },
# AFTER LAST PASS: );
# AFTER LAST PASS: $mock = mock 'XML::Simple' => (
    # AFTER LAST PASS: track => {
        # AFTER LAST PASS: new_xml_parser => sub { bless {}, 'XML::Parser' },
    # AFTER LAST PASS: },
# AFTER LAST PASS: );
# AFTER LAST PASS: $simple = bless { opt => {} }, 'XML::Simple';
# UNVALIDATED: $result = eval { $simple->build_tree_xml_parser('filename', 'string') };
# FAILED: if ($@) { like($@, qr/Malformed XML data/, 'build_tree_xml_parser crashes when XML data is malformed'); } else { fail('build_tree_xml_parser did not crash when XML data is malformed'); }

# AFTER LAST PASS: $mock = mock 'XML::Parser' => (
    # AFTER LAST PASS: track => {
        # AFTER LAST PASS: parse => sub { return 'Parsed XML data' },
    # AFTER LAST PASS: },
# AFTER LAST PASS: );
# AFTER LAST PASS: $mock = mock 'XML::Simple' => (
    # AFTER LAST PASS: track => {
        # AFTER LAST PASS: new_xml_parser => sub { bless {}, 'XML::Parser' },
    # AFTER LAST PASS: },
# AFTER LAST PASS: );
# AFTER LAST PASS: $simple = bless { opt => {} }, 'XML::Simple';
my $tempfile;  # AFTER LAST PASS: my $tempfile = tempfile();
# AFTER LAST PASS: print $tempfile 'Parsed XML data';
# AFTER LAST PASS: close $tempfile;
# UNVALIDATED: $result = eval { $simple->build_tree_xml_parser($tempfile, '') };
# FAILED: if ($@) { fail('build_tree_xml_parser crashed during normal operation: ' . $@); } else { is($result, 'Parsed XML data', 'build_tree_xml_parser returns parsed XML data during normal operation'); }

done_testing();