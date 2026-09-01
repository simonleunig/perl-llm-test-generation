use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::spew_lines"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'spew_lines is defined'); }

# Test case 1: Test with scalar content
my ($fh, $filename) = tempfile();
my $file = Path::Class::File->new($filename);
my $content = 'Hello, World!';
my $result = eval { $file->spew_lines($content) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result with scalar content'); }

# Test case 2: Test with array reference content
$content = ['Line 1', 'Line 2', 'Line 3'];
$result = eval { $file->spew_lines($content) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result with array reference content'); }

# Test case 3: Test with invalid content
$content = {};
$result = eval { $file->spew_lines($content) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result, 'Function returns undefined with invalid content'); }

# Test case 4: Test with file that cannot be written to
my $readonly_file = Path::Class::File->new('/dev/null');
$result = eval { $readonly_file->spew_lines($content) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result, 'Function returns undefined with readonly file'); }

done_testing();
