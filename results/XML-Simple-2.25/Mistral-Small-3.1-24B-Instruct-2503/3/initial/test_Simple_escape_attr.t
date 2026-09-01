use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }  # Use actual module name from package declaration

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::escape_attr"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'escape_attr is defined'); }

# Mock the escape_value method
mock 'XML::Simple', escape_value => sub {
    my ($self, $value) = @_;
    $value =~ s/&/&amp;/g;
    $value =~ s/</&lt;/g;
    $value =~ s/>/&gt;/g;
    $value =~ s/"/&quot;/g;
    return $value;
};

# Test cases with eval protection

# Normal case with special characters
my $result = eval { XML::Simple->escape_attr('test "<>&"') };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, 'test &quot;&lt;&gt;&amp;&quot;', 'escape_attr handles special characters correctly');
}

# Edge case: empty string
$result = eval { XML::Simple->escape_attr('') };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, '', 'escape_attr handles empty string correctly');
}

# Edge case: no special characters
$result = eval { XML::Simple->escape_attr('normal string') };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, 'normal string', 'escape_attr handles normal string correctly');
}

# Edge case: non-ASCII characters
$result = eval { XML::Simple->escape_attr('non-ASCII: éèê') };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, 'non-ASCII: éèê', 'escape_attr handles non-ASCII characters correctly');
}

# Error case: invalid input (though not explicitly handled, should not crash)
$result = eval { XML::Simple->escape_attr(undef) };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(!defined $result, 'escape_attr handles undefined input gracefully');
}

done_testing();
