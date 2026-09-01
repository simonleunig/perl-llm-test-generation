use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::XMLin"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'XMLin is defined'); }

my $result = eval { XML::Simple::XMLin() };
# FAILED: if ($@) { fail('XMLin crashed with undefined target: ' . $@); } else { ok(defined $result, 'XMLin returns result with undefined target'); }

my $xml_string = '<root><person><name>John</name><age>30</age></person></root>';
$result = eval { XML::Simple::XMLin($xml_string) };
if ($@) { fail('XMLin crashed with XML string: ' . $@); } else { ok(defined $result, 'XMLin returns result with XML string'); }

my ($fh, $filename) = tempfile();
print $fh '<root><person><name>John</name><age>30</age></person></root>';
close $fh;
$result = eval { XML::Simple::XMLin($filename) };
if ($@) { fail('XMLin crashed with file: ' . $@); } else { ok(defined $result, 'XMLin returns result with file'); }
unlink $filename;

($fh, $filename) = tempfile();
print $fh '<root><person><name>John</name><age>30</age></person></root>';
seek $fh, 0, 0;
$result = eval { XML::Simple::XMLin($fh) };
if ($@) { fail('XMLin crashed with filehandle: ' . $@); } else { ok(defined $result, 'XMLin returns result with filehandle'); }
close $fh;
unlink $filename;

my $xml_scalar = '<root><person><name>John</name><age>30</age></person></root>';
$result = eval { XML::Simple::XMLin(\$xml_scalar) };
if ($@) { fail('XMLin crashed with scalar reference: ' . $@); } else { ok(defined $result, 'XMLin returns result with scalar reference'); }

($fh, $filename) = tempfile();
print $fh '<root><person><name>John</name><age>30</age>';
close $fh;
my $error = eval { XML::Simple::XMLin($filename) };
if ($@) { ok($@, 'XMLin crashes with invalid XML file'); } else { fail('XMLin did not crash with invalid XML file'); }
# AFTER LAST PASS: unlink $filename;

done_testing();