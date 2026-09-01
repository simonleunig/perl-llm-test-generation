use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::XMLin"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'XMLin is defined'); }

# Test case 1: Undefined target
my $result = eval { XML::Simple::XMLin() };
if ($@) { fail('XMLin crashed with undefined target: ' . $@); } else { ok(defined $result, 'XMLin returns result with undefined target'); }

# Test case 2: Target is a string containing XML
my $xml_string = '<root><person><name>John</name><age>30</age></person></root>';
$result = eval { XML::Simple::XMLin($xml_string) };
if ($@) { fail('XMLin crashed with XML string: ' . $@); } else { ok(defined $result, 'XMLin returns result with XML string'); }

# Test case 3: Target is a file
my ($fh, $filename) = tempfile();
print $fh '<root><person><name>John</name><age>30</age></person></root>';
close $fh;
$result = eval { XML::Simple::XMLin($filename) };
if ($@) { fail('XMLin crashed with file: ' . $@); } else { ok(defined $result, 'XMLin returns result with file'); }
unlink $filename;

# Test case 4: Target is a filehandle
($fh, $filename) = tempfile();
print $fh '<root><person><name>John</name><age>30</age></person></root>';
seek $fh, 0, 0;
$result = eval { XML::Simple::XMLin($fh) };
if ($@) { fail('XMLin crashed with filehandle: ' . $@); } else { ok(defined $result, 'XMLin returns result with filehandle'); }
close $fh;
unlink $filename;

# Test case 5: Target is a scalar reference
my $xml_scalar = '<root><person><name>John</name><age>30</age></person></root>';
$result = eval { XML::Simple::XMLin(\$xml_scalar) };
if ($@) { fail('XMLin crashed with scalar reference: ' . $@); } else { ok(defined $result, 'XMLin returns result with scalar reference'); }

# Test case 6: Target is a file with invalid XML
($fh, $filename) = tempfile();
print $fh '<root><person><name>John</name><age>30</age>';
close $fh;
$result = eval { XML::Simple::XMLin($filename) };
if ($@) { ok($@, 'XMLin crashes with invalid XML file'); } else { fail('XMLin did not crash with invalid XML file'); }
unlink $filename;

done_testing();
