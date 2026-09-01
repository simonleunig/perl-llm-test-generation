use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }  # Use actual module name from package declaration

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::XMLin"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'XMLin is defined'); }

# Mock dependencies
mock 'XML::Simple' => (
    parse_file => sub { return { parsed => 'file' } },
    parse_string => sub { return { parsed => 'string' } },
    parse_fh => sub { return { parsed => 'fh' } },
    _get_object => sub { return bless {}, 'XML::Simple' },
);

# Test case: Undefined input
my $result = eval { XML::Simple::XMLin(undef) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, { parsed => 'file' }, 'XMLin with undef input'); }

# Test case: Input from STDIN
mock 'XML::Simple' => (
    parse_string => sub { return { parsed => 'stdin' } },
);
local $/ = undef;
my $stdin = \*STDIN;
open(my $stdin_fh, '<', \$stdin) or die "Cannot open STDIN: $!";
$stdin = '-';
$result = eval { XML::Simple::XMLin($stdin) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, { parsed => 'stdin' }, 'XMLin with STDIN input'); }

# Test case: Input as a scalar reference
my $xml_string = '<root><child>data</child></root>';
$result = eval { XML::Simple::XMLin(\$xml_string) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, { parsed => 'string' }, 'XMLin with scalar reference input'); }

# Test case: Input as a file handle
my ($fh, $filename) = tempfile();
print $fh '<root><child>data</child></root>';
seek $fh, 0, 0;
$result = eval { XML::Simple::XMLin($fh) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, { parsed => 'fh' }, 'XMLin with file handle input'); }

# Test case: Input as a file path
my $tempdir = tempdir(CLEANUP => 1);
my $filepath = File::Spec->catfile($tempdir, 'test.xml');
open(my $file_fh, '>', $filepath) or die "Cannot open file: $!";
print $file_fh '<root><child>data</child></root>';
close($file_fh);
$result = eval { XML::Simple::XMLin($filepath) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, { parsed => 'file' }, 'XMLin with file path input'); }

# Test case: Input as a string containing XML
$xml_string = '<root><child>data</child></root>';
$result = eval { XML::Simple::XMLin($xml_string) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, { parsed => 'string' }, 'XMLin with XML string input'); }

# Clean up mocks
unmock 'XML::Simple';

done_testing();
