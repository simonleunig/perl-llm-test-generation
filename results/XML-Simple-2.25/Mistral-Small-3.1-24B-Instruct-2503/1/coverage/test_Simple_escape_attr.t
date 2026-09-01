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

# Mock the escape_value function
my $mock;
eval { require XML::Simple; };
if ($@) {
    # DEPENDENCY MISSING: XML::Simple - mock skipped
} else {
    no strict 'refs';
    if (defined &{"XML::Simple::escape_value"}) {
        $mock = mock 'XML::Simple' => ( override => [ escape_value => sub {
            my ($self, $value) = @_;
            $value =~ s/&/&amp;/g;
            $value =~ s/</&lt;/g;
            $value =~ s/>/&gt;/g;
            $value =~ s/"/&quot;/g;
            return $value;
        } ] );
    } else {
        $mock = mock 'XML::Simple' => ( add => [ escape_value => sub {
            my ($self, $value) = @_;
            $value =~ s/&/&amp;/g;
            $value =~ s/</&lt;/g;
            $value =~ s/>/&gt;/g;
            $value =~ s/"/&quot;/g;
            return $value;
        } ] );
    }
}

# Test cases with eval protection

# Normal case
my $result = eval { XML::Simple->escape_attr('test value') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'test value', 'Normal case'); }

# Empty string
$result = eval { XML::Simple->escape_attr('') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, '', 'Empty string'); }

# Special characters
$result = eval { XML::Simple->escape_attr('& < > "') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, '&amp; &lt; &gt; &quot;', 'Special characters'); }

# Non-ASCII characters (assuming NumericEscape is not set)
$result = eval { XML::Simple->escape_attr('é') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'é', 'Non-ASCII characters'); }

# Edge case: very long string
my $long_string = 'a' x 10000;
$result = eval { XML::Simple->escape_attr($long_string) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, $long_string, 'Very long string'); }

done_testing();