use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::characters"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'characters is defined'); }

# Test case 1: Empty input
my $xml_simple = bless {}, 'XML::Simple';
my $chars = { Data => '' };
my $result = eval { $xml_simple->characters($chars) };
if ($@) { fail('Function crashed with empty input: ' . $@); } else { ok(1, 'Function handles empty input'); }

# Test case 2: Non-empty input
$xml_simple = bless { curlist => [] }, 'XML::Simple';
$chars = { Data => 'test' };
$result = eval { $xml_simple->characters($chars) };
if ($@) { fail('Function crashed with non-empty input: ' . $@); } else { ok(1, 'Function handles non-empty input'); }

# Test case 3: Append to existing text
$xml_simple = bless { curlist => [0 => 'existing'] }, 'XML::Simple';
$chars = { Data => 'text' };
$result = eval { $xml_simple->characters($chars) };
if ($@) { fail('Function crashed when appending to existing text: ' . $@); } else { ok(1, 'Function appends to existing text'); }

# Test case 4: New text when previous element is not '0'
$xml_simple = bless { curlist => ['not_text'] }, 'XML::Simple';
$chars = { Data => 'new_text' };
$result = eval { $xml_simple->characters($chars) };
if ($@) { fail('Function crashed when adding new text: ' . $@); } else { ok(1, 'Function adds new text'); }

done_testing();
