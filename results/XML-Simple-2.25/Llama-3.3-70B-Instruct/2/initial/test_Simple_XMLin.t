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

# Test case 1: Empty input
my $result = eval { XML::Simple::XMLin(); };
if ($@) { fail('XMLin crashed with empty input: ' . $@); } else { ok(defined $result, 'XMLin returns result with empty input'); }

# Test case 2: Invalid input
$result = eval { XML::Simple::XMLin('invalid'); };
if ($@) { fail('XMLin crashed with invalid input: ' . $@); } else { ok(defined $result, 'XMLin returns result with invalid input'); }

# Test case 3: Valid XML string
my ($fh, $filename) = tempfile();
print $fh '<root><person><name>John</name></person></root>';
close $fh;
$result = eval { XML::Simple::XMLin($filename); };
if ($@) { fail('XMLin crashed with valid XML string: ' . $@); } else { ok(defined $result, 'XMLin returns result with valid XML string'); }
unlink $filename;

# Test case 4: Valid XML file
($fh, $filename) = tempfile();
print $fh '<root><person><name>John</name></person></root>';
close $fh;
$result = eval { XML::Simple::XMLin($filename); };
if ($@) { fail('XMLin crashed with valid XML file: ' . $@); } else { ok(defined $result, 'XMLin returns result with valid XML file'); }
unlink $filename;

# Test case 5: XML file with non-ASCII characters
($fh, $filename) = tempfile();
print $fh '<root><person><name>Jöhn</name></person></root>';
close $fh;
$result = eval { XML::Simple::XMLin($filename); };
if ($@) { fail('XMLin crashed with XML file containing non-ASCII characters: ' . $@); } else { ok(defined $result, 'XMLin returns result with XML file containing non-ASCII characters'); }
unlink $filename;

# Test case 6: XML string with missing or duplicate keys
$result = eval { XML::Simple::XMLin('<root><person><name>John</name><name>Jane</name></person></root>'); };
if ($@) { fail('XMLin crashed with XML string containing missing or duplicate keys: ' . $@); } else { ok(defined $result, 'XMLin returns result with XML string containing missing or duplicate keys'); }

done_testing();
