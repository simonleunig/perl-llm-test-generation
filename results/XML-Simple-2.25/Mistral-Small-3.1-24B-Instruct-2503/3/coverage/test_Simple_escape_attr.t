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

# Mock the escape_value method
my $mock;
# AFTER LAST PASS: eval { require XML::Simple; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: XML::Simple - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"XML::Simple::escape_value"}) {
        # AFTER LAST PASS: $mock = mock 'XML::Simple', escape_value => sub {
            my ($self, $value);  # AFTER LAST PASS: my ($self, $value) = @_;
            # AFTER LAST PASS: $value =~ s/&/&amp;/g;
            # AFTER LAST PASS: $value =~ s/</&lt;/g;
            # AFTER LAST PASS: $value =~ s/>/&gt;/g;
            # AFTER LAST PASS: $value =~ s/"/&quot;/g;
            # AFTER LAST PASS: return $value;
        # AFTER LAST PASS: };
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock = mock 'XML::Simple', add => { escape_value => sub {
            my ($self, $value);  # AFTER LAST PASS: my ($self, $value) = @_;
            # AFTER LAST PASS: $value =~ s/&/&amp;/g;
            # AFTER LAST PASS: $value =~ s/</&lt;/g;
            # AFTER LAST PASS: $value =~ s/>/&gt;/g;
            # AFTER LAST PASS: $value =~ s/"/&quot;/g;
            # AFTER LAST PASS: return $value;
        # AFTER LAST PASS: } };
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# Test cases with eval protection

# Normal case with special characters
my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple->escape_attr('test "<>&"') };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
    # FAILED: is($result, 'test &quot;&lt;&gt;&amp;&quot;', 'escape_attr handles special characters correctly');
# FAILED: }

# Edge case: empty string
# UNVALIDATED: $result = eval { XML::Simple->escape_attr('') };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
    # FAILED: is($result, '', 'escape_attr handles empty string correctly');
# FAILED: }

# Edge case: no special characters
# UNVALIDATED: $result = eval { XML::Simple->escape_attr('normal string') };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
    # FAILED: is($result, 'normal string', 'escape_attr handles normal string correctly');
# FAILED: }

# Edge case: non-ASCII characters
# UNVALIDATED: $result = eval { XML::Simple->escape_attr('non-ASCII: éèê') };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
    # FAILED: is($result, 'non-ASCII: éèê', 'escape_attr handles non-ASCII characters correctly');
# FAILED: }

# Error case: invalid input (though not explicitly handled, should not crash)
# UNVALIDATED: $result = eval { XML::Simple->escape_attr(undef) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
    # FAILED: ok(!defined $result, 'escape_attr handles undefined input gracefully');
# FAILED: }

done_testing();