use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::build_tree"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'build_tree is defined'); }

# Test case 1: Test with a valid XML file
my ($fh, $filename) = tempfile();
print $fh '<root><person><name>John</name><age>30</age></person></root>';
close $fh;
my $xml_simple = bless {}, 'XML::Simple';
my $result = eval { $xml_simple->build_tree($filename) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result with valid XML file'); }

# Test case 2: Test with a valid XML string
my $xml_string = '<root><person><name>John</name><age>30</age></person></root>';
$result = eval { $xml_simple->build_tree(undef, \$xml_string) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result with valid XML string'); }

# Test case 3: Test with an invalid XML file
($fh, $filename) = tempfile();
print $fh '<root><person><name>John</name><age>30</age>';
close $fh;
$result = eval { $xml_simple->build_tree($filename) };
if ($@) { ok($@, 'Function raises error with invalid XML file'); } else { fail('Function did not raise error with invalid XML file'); }

# Test case 4: Test with an invalid XML string
$xml_string = '<root><person><name>John</name><age>30</age>';
$result = eval { $xml_simple->build_tree(undef, \$xml_string) };
if ($@) { ok($@, 'Function raises error with invalid XML string'); } else { fail('Function did not raise error with invalid XML string'); }

# Test case 5: Test with a non-existent XML file
$result = eval { $xml_simple->build_tree('non_existent_file.xml') };
if ($@) { ok($@, 'Function raises error with non-existent XML file'); } else { fail('Function did not raise error with non-existent XML file'); }

# Test case 6: Test with an empty XML string
$xml_string = '';
$result = eval { $xml_simple->build_tree(undef, \$xml_string) };
if ($@) { ok($@, 'Function raises error with empty XML string'); } else { fail('Function did not raise error with empty XML string'); }

done_testing();
