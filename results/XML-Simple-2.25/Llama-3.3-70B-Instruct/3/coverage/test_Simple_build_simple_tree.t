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
my $result = eval { XML::Simple->new->build_simple_tree(\$xml_string) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }

my $xml_string_keeproot = '<root><person><name>John</name><age>30</age></person></root>';
my $result_keeproot = eval { XML::Simple->new->build_simple_tree(\$xml_string_keeproot, 'keeproot' => 1) };
if ($@) { fail('Function crashed with keeproot: ' . $@); } else { ok(defined $result_keeproot, 'Function returns result with keeproot'); }

my $invalid_xml = '<root><person><name>John</name><age>30</age>';
my $result_invalid = eval { XML::Simple->new->build_simple_tree(\$invalid_xml) };
if ($@) { pass('Function crashed with invalid XML: ' . $@); } else { fail('Function did not crash with invalid XML'); }

my $empty_xml = '';
my $result_empty = eval { XML::Simple->new->build_simple_tree(\$empty_xml) };
if ($@) { pass('Function crashed with empty XML: ' . $@); } else { fail('Function did not crash with empty XML'); }

done_testing();