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
eval { require XML::Simple; };
if ($@) {
    # DEPENDENCY MISSING: XML::Simple - mock skipped
} else {
    no strict 'refs';
    if (defined &{"XML::Simple::numeric_escape"}) {
        $mock_self = mock 'XML::Simple' => ( override => {
            numeric_escape => sub {
                my ($self, $data, $level) = @_;
                if ($self->{opt}->{numericescape} eq '2') {
                    $data =~ s/([^\x00-\x7F])/'&#' . ord($1) . ';'/gse;
                } else {
                    $data =~ s/([^\x00-\xFF])/'&#' . ord($1) . ';'/gse;
                }
                return $data;
            }
        });
    } else {
        $mock_self = mock 'XML::Simple' => ( add => {
            numeric_escape => sub {
                my ($self, $data, $level) = @_;
                if ($self->{opt}->{numericescape} eq '2') {
                    $data =~ s/([^\x00-\x7F])/'&#' . ord($1) . ';'/gse;
                } else {
                    $data =~ s/([^\x00-\xFF])/'&#' . ord($1) . ';'/gse;
                }
                return $data;
            }
        });
    }
}

# Test case 1: Empty string input
my $result = eval { XML::Simple::numeric_escape($mock_self, '', 1) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, '', 'Empty string input returns empty string'); }

# Test case 2: ASCII characters only
$result = eval { XML::Simple::numeric_escape($mock_self, 'Hello World', 1) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'Hello World', 'ASCII characters remain unchanged'); }

# Test case 3: Non-ASCII characters with level 1
$result = eval { XML::Simple::numeric_escape($mock_self, 'Hello World €', 1) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'Hello World &#8364;', 'Non-ASCII characters escaped with level 1'); }

# Test case 4: Non-ASCII characters with level 2
$result = eval { XML::Simple::numeric_escape($mock_self, 'Hello World €', 2) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'Hello World &#8364;', 'Non-ASCII characters escaped with level 2'); }

# Test case 5: Non-ASCII characters with invalid level
$result = eval { XML::Simple::numeric_escape($mock_self, 'Hello World €', 3) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'Hello World &#8364;', 'Non-ASCII characters escaped with invalid level'); }

# Test case 6: Mixed ASCII and non-ASCII characters
$result = eval { XML::Simple::numeric_escape($mock_self, 'Hello World € 你好', 1) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'Hello World &#8364; &#19990;&#20013;', 'Mixed characters escaped correctly'); }

# Test case 7: Special characters
$result = eval { XML::Simple::numeric_escape($mock_self, 'Hello World <>&', 1) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'Hello World &#60;&#62;&#38;', 'Special characters escaped correctly'); }

done_testing();