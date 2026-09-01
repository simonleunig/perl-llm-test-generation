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
my $result = eval { XML::Simple->XMLin(); };
if ($@) { fail('XMLin crashed with undefined target: ' . $@); } else { ok(defined $result, 'XMLin returns result with undefined target'); }

# Test case 2: Target is '-'
my ($fh, $filename) = tempfile();
print $fh '<root><foo>bar</foo></root>';
seek $fh, 0, 0;
my $stdin_mock = mock 'IO::Handle' => ( tie => sub { return $fh } );
local *STDIN = $stdin_mock->handle;
$result = eval { XML::Simple->XMLin('-'); };
if ($@) { fail('XMLin crashed with target \'-\': ' . $@); } else { ok(defined $result, 'XMLin returns result with target \'-\''); }

# Test case 3: Target is a scalar reference
my $scalar_ref = \'<root><foo>bar</foo></root>';
$result = eval { XML::Simple->XMLin($scalar_ref); };
if ($@) { fail('XMLin crashed with scalar reference target: ' . $@); } else { ok(defined $result, 'XMLin returns result with scalar reference target'); }

# Test case 4: Target is a filehandle
($fh, $filename) = tempfile();
print $fh '<root><foo>bar</foo></root>';
seek $fh, 0, 0;
$result = eval { XML::Simple->XMLin($fh); };
if ($@) { fail('XMLin crashed with filehandle target: ' . $@); } else { ok(defined $result, 'XMLin returns result with filehandle target'); }

# Test case 5: Target is a string containing XML
my $xml_string = '<root><foo>bar</foo></root>';
$result = eval { XML::Simple->XMLin($xml_string); };
if ($@) { fail('XMLin crashed with XML string target: ' . $@); } else { ok(defined $result, 'XMLin returns result with XML string target'); }

# Test case 6: Target is a filename
($fh, $filename) = tempfile();
print $fh '<root><foo>bar</foo></root>';
close $fh;
$result = eval { XML::Simple->XMLin($filename); };
if ($@) { fail('XMLin crashed with filename target: ' . $@); } else { ok(defined $result, 'XMLin returns result with filename target'); }

done_testing();
