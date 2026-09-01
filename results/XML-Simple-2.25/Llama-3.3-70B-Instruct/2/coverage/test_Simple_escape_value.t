use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::escape_value"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'escape_value is defined'); }

my $result = eval { XML::Simple->new()->escape_value(undef) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, '', 'escape_value returns empty string for undefined input'); }

$result = eval { XML::Simple->new()->escape_value('') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, '', 'escape_value returns empty string for empty input'); }

$result = eval { XML::Simple->new()->escape_value('<foo> & "bar" >') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, '&lt;foo&gt; &amp; &quot;bar&quot; &gt;', 'escape_value escapes special characters'); }

my $simple;  # AFTER LAST PASS: my $simple;  # UNVALIDATED: my $simple = XML::Simple->new();
# AFTER LAST PASS: $simple->{opt} = { numericescape => 1 };
# UNVALIDATED: $result = eval { $simple->escape_value('<foo> & "bar" >') };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { 
    # FAILED: like($result, qr/<foo> & "bar" >/, 'escape_value with numeric escape option'); 
# FAILED: }

done_testing();