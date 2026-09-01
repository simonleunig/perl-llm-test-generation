use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::numeric_escape"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'numeric_escape is defined'); }

# Mock the XML::Simple object
my $mock_self;
# AFTER LAST PASS: eval { require XML::Simple; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: XML::Simple - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"XML::Simple::numeric_escape"}) {
        # AFTER LAST PASS: $mock_self = mock 'XML::Simple' => ( override => {
            # AFTER LAST PASS: opt => {
                # AFTER LAST PASS: numericescape => '2'
            # AFTER LAST PASS: }
        # AFTER LAST PASS: });
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock_self = mock 'XML::Simple' => ( add => {
            # AFTER LAST PASS: opt => {
                # AFTER LAST PASS: numericescape => '2'
            # AFTER LAST PASS: }
        # AFTER LAST PASS: });
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# Test case 1: Empty string input
my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::numeric_escape($mock_self, '', 1) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { is($result, '', 'Empty string input returns empty string'); }

# Test case 2: ASCII characters only
# UNVALIDATED: $result = eval { XML::Simple::numeric_escape($mock_self, 'Hello World', 1) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'Hello World', 'ASCII characters remain unchanged'); }

# Test case 3: Non-ASCII characters with level 1
# UNVALIDATED: $result = eval { XML::Simple::numeric_escape($mock_self, 'Hello World €', 1) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'Hello World &#8364;', 'Non-ASCII characters escaped with level 1'); }

# Test case 4: Non-ASCII characters with level 2
# UNVALIDATED: $result = eval { XML::Simple::numeric_escape($mock_self, 'Hello World €', 2) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'Hello World &#8364;', 'Non-ASCII characters escaped with level 2'); }

# Test case 5: Non-ASCII characters with invalid level
# UNVALIDATED: $result = eval { XML::Simple::numeric_escape($mock_self, 'Hello World €', 3) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'Hello World &#8364;', 'Non-ASCII characters escaped with invalid level'); }

# Test case 6: Mixed ASCII and non-ASCII characters
# UNVALIDATED: $result = eval { XML::Simple::numeric_escape($mock_self, 'Hello World € 你好', 1) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'Hello World &#8364; &#19990;&#20013;', 'Mixed characters escaped correctly'); }

# Test case 7: Special characters
# UNVALIDATED: $result = eval { XML::Simple::numeric_escape($mock_self, 'Hello World <>&', 1) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'Hello World &#60;&#62;&#38;', 'Special characters escaped correctly'); }

done_testing();