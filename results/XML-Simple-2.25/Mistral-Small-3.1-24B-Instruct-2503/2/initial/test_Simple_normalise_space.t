use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }  # Use actual module name from package declaration

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::normalise_space"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'normalise_space is defined'); }

# Test cases with eval protection

# Test with normal text
my $result = eval { XML::Simple::normalise_space(undef, '  This is a test.  ') };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, 'This is a test.', 'Normal text is normalized correctly');
}

# Test with leading and trailing whitespace
$result = eval { XML::Simple::normalise_space(undef, '   Leading and trailing spaces   ') };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, 'Leading and trailing spaces', 'Leading and trailing spaces are removed');
}

# Test with multiple spaces between words
$result = eval { XML::Simple::normalise_space(undef, 'Multiple    spaces   between   words') };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, 'Multiple spaces between words', 'Multiple spaces are collapsed');
}

# Test with empty string
$result = eval { XML::Simple::normalise_space(undef, '') };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, '', 'Empty string returns empty string');
}

# Test with string containing only whitespace
$result = eval { XML::Simple::normalise_space(undef, '     ') };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, '', 'String with only whitespace returns empty string');
}

# Test with mixed content
$result = eval { XML::Simple::normalise_space(undef, '  Mixed   content  with   spaces  ') };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, 'Mixed content with spaces', 'Mixed content is normalized correctly');
}

# Test with newline characters
$result = eval { XML::Simple::normalise_space(undef, "  Newline\ncharacters  ") };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, 'Newline characters', 'Newline characters are normalized correctly');
}

# Test with tab characters
$result = eval { XML::Simple::normalise_space(undef, "  Tab\tcharacters  ") };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, 'Tab characters', 'Tab characters are normalized correctly');
}

# Test with special characters
$result = eval { XML::Simple::normalise_space(undef, '  Special!@#$%^&*()_+ characters  ') };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, 'Special!@#$%^&*()_+ characters', 'Special characters are normalized correctly');
}

done_testing();
