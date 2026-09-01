use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }  # Use actual module name from package declaration

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::escape_value"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'escape_value is defined'); }

# Mock the numeric_escape method
mock 'XML::Simple' => (
    override => [
        numeric_escape => sub {
            my ($self, $data, $level) = @_;
            if ($level == 1) {
                $data =~ s/[^\x00-\xFF]/sprintf("&#x%X;", ord($1))/eg;
            } elsif ($level == 2) {
                $data =~ s/[^\x00-\x7F]/sprintf("&#x%X;", ord($1))/eg;
            }
            return $data;
        }
    ]
);

# Test cases with eval protection
my $self = bless { opt => { numericescape => 0 } }, 'XML::Simple';

# Test with undef data
my $result = eval { XML::Simple::escape_value($self, undef) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, '', 'escape_value returns empty string for undef data'); }

# Test with normal data
$result = eval { XML::Simple::escape_value($self, 'test <data> with & special "chars"') };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, 'test &lt;data&gt; with &amp; special &quot;chars&quot;', 'escape_value escapes special characters correctly');
}

# Test with numeric escape level 1
$self->{opt}->{numericescape} = 1;
$result = eval { XML::Simple::escape_value($self, 'test data with non-ASCII: €') };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, 'test data with non-ASCII: &#x20AC;', 'escape_value escapes non-ASCII characters correctly with level 1');
}

# Test with numeric escape level 2
$self->{opt}->{numericescape} = 2;
$result = eval { XML::Simple::escape_value($self, 'test data with non-ASCII: €') };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, 'test data with non-ASCII: &#x20AC;', 'escape_value escapes non-ASCII characters correctly with level 2');
}

# Test with numeric escape level 0 (no numeric escape)
$self->{opt}->{numericescape} = 0;
$result = eval { XML::Simple::escape_value($self, 'test data with non-ASCII: €') };
if ($@) { fail('Function crashed: ' . $@); } else {
    is($result, 'test data with non-ASCII: €', 'escape_value does not escape non-ASCII characters with level 0');
}

done_testing();
