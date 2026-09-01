use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::escape_value"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'escape_value is defined'); }

# Test case 1: Undefined input data
my $result = eval { XML::Simple->new()->escape_value(undef) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, '', 'escape_value returns empty string for undefined input'); }

# Test case 2: Empty input data
$result = eval { XML::Simple->new()->escape_value('') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, '', 'escape_value returns empty string for empty input'); }

# Test case 3: Input data with special characters
$result = eval { XML::Simple->new()->escape_value('<foo>&bar</foo>') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, '&lt;foo&gt;&amp;bar&lt;/foo&gt;', 'escape_value escapes special characters'); }

# Test case 4: Input data with numeric escape option
my $xml_simple = XML::Simple->new();
$xml_simple->{opt} = { numericescape => 1 };
$result = eval { $xml_simple->escape_value('<foo>&bar</foo>') };
if ($@) { fail('Function crashed: ' . $@); } else { 
    # Since numeric_escape is not implemented in this example, 
    # we assume it will be implemented and tested separately.
    # For now, we just check if the function calls numeric_escape.
    my $mock = mock 'XML::Simple' => ( 
        track => 1, 
        override => [ 
            numeric_escape => sub { return 'mocked_numeric_escape' }, 
        ], 
    );
    $result = eval { $xml_simple->escape_value('<foo>&bar</foo>') };
    if ($@) { fail('Function crashed: ' . $@); } else { 
        is($result, 'mocked_numeric_escape', 'escape_value calls numeric_escape with numeric escape option'); 
    }
}

done_testing();
