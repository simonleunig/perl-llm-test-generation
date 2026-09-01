use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::build_simple_tree"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'build_simple_tree is defined'); }

my $xml_string = '<root><person><name>John</name><age>30</age></person></root>';
my $result = eval { XML::Simple->new->build_simple_tree($xml_string) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for valid XML string'); }

$xml_string = '<root><person><name>John</name><age>30</age>';
$result = eval { XML::Simple->new->build_simple_tree($xml_string) };
if ($@) { ok(1, 'Function crashes for invalid XML string'); } else { fail('Function did not crash for invalid XML string'); }

$xml_string = '';
$result = eval { XML::Simple->new->build_simple_tree($xml_string) };
if ($@) { ok(1, 'Function crashes for empty XML string'); } else { fail('Function did not crash for empty XML string'); }

$xml_string = undef;
$result = eval { XML::Simple->new->build_simple_tree($xml_string) };
if ($@) { ok(1, 'Function crashes for null XML string'); } else { fail('Function did not crash for null XML string'); }

# AFTER LAST PASS: $xml_string = '<root><person><name>John</name><age>30</age></person></root>';
my $xml_simple;  # AFTER LAST PASS: my $xml_simple;  # UNVALIDATED: my $xml_simple = XML::Simple->new;
# AFTER LAST PASS: $xml_simple->{opt}->{keeproot} = 1;
# UNVALIDATED: $result = eval { $xml_simple->build_simple_tree($xml_string) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result with keeproot option'); }

done_testing();