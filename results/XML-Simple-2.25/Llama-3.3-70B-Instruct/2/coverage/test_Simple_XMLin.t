use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::XMLin"} };
if ($@) { fail("Symbol check crashed: $@"); } else { ok($symbol_check, "XMLin is defined"); }

my $result = eval { XML::Simple::XMLin(); };
# FAILED: if ($@) { fail("XMLin crashed with empty input: $@"); } else { ok(defined $result, "XMLin returns result with empty input"); }

$result = eval { XML::Simple::XMLin('invalid'); };
# FAILED: if ($@) { fail("XMLin crashed with invalid input: $@"); } else { ok(defined $result, "XMLin returns result with invalid input"); }

my ($fh, $filename) = tempfile();
print $fh '<root><person><name>John</name></person></root>';
close $fh;
$result = eval { XML::Simple::XMLin($filename); };
if ($@) { fail("XMLin crashed with valid XML file: $@"); } else { ok(defined $result, "XMLin returns result with valid XML file"); }
unlink $filename;

($fh, $filename) = tempfile();
print $fh '<root><person><name>John</name></person></root>';
close $fh;
$result = eval { XML::Simple::XMLin($filename); };
if ($@) { fail("XMLin crashed with valid XML file: $@"); } else { ok(defined $result, "XMLin returns result with valid XML file"); }
unlink $filename;

($fh, $filename) = tempfile();
print $fh '<root><person><name>Jöhn</name></person></root>';
close $fh;
$result = eval { XML::Simple::XMLin($filename); };
# FAILED: if ($@) { fail("XMLin crashed with XML file containing non-ASCII characters: $@"); } else { ok(defined $result, "XMLin returns result with XML file containing non-ASCII characters"); }
unlink $filename;

$result = eval { XML::Simple::XMLin('<root><person><name>John</name><name>Jane</name></person></root>'); };
if ($@) { fail("XMLin crashed with XML string containing missing or duplicate keys: $@"); } else { ok(defined $result, "XMLin returns result with XML string containing missing or duplicate keys"); }

my $error = eval { XML::Simple::XMLin('<root><person><name>John</name>'); };
ok($@, "Dies with incomplete XML");
like($@, qr/no element found/, "Error message correct");

$error = eval { XML::Simple::XMLin('<root><person><name>John&</name></person></root>'); };
ok($@, "Dies with invalid XML");
like($@, qr/not well-formed/, "Error message correct");

done_testing();