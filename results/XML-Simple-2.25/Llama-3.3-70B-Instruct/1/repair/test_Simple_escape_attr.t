use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::escape_attr"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'escape_attr is defined'); }

# Test case 1: Normal attribute value
my $result1 = eval { XML::Simple->new()->escape_attr('normal_value') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result1, 'Function returns result for normal value'); }
is($result1, 'normal_value', 'Normal value is not modified');

# Test case 2: Attribute value with special characters
my $result2 = eval { XML::Simple->new()->escape_attr('<value> with & and "') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result2, 'Function returns result for value with special characters'); }
is($result2, '&lt;value&gt; with &amp; and &quot;', 'Special characters are properly escaped');

# Test case 3: Attribute value with non-ASCII characters
my $result3 = eval { XML::Simple->new()->escape_attr('value with é and ü') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result3, 'Function returns result for value with non-ASCII characters'); }
is($result3, 'value with é and ü', 'Non-ASCII characters are preserved');

# Test case 4: Empty attribute value
my $result4 = eval { XML::Simple->new()->escape_attr('') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result4, 'Function returns result for empty value'); }
is($result4, '', 'Empty value is not modified');

done_testing();
