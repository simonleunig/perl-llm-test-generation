use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }  # Use actual module name from package declaration

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::start_document"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'start_document is defined'); }

# Mock the handle_options method
mock 'XML::Simple', handle_options => sub {
    my ($self, $mode) = @_;
    $self->{opt} = { mode => $mode };
};

# Test case: start_document with no options set
{
    my $xml_simple = bless {}, 'XML::Simple';
    my $result = eval { $xml_simple->start_document() };
    if ($@) { fail('start_document crashed: ' . $@); } else {
        ok(defined $result, 'start_document returns defined result');
        is(ref($xml_simple->{lists}), 'ARRAY', 'lists is initialized as an array');
        is(ref($xml_simple->{curlist}), 'ARRAY', 'curlist is initialized as an array');
        is(ref($xml_simple->{tree}), 'ARRAY', 'tree is initialized as an array');
        is($xml_simple->{opt}->{mode}, 'in', 'handle_options was called with correct argument');
    }
}

# Test case: start_document with options already set
{
    my $xml_simple = bless { opt => { mode => 'out' } }, 'XML::Simple';
    my $result = eval { $xml_simple->start_document() };
    if ($@) { fail('start_document crashed: ' . $@); } else {
        ok(defined $result, 'start_document returns defined result');
        is(ref($xml_simple->{lists}), 'ARRAY', 'lists is initialized as an array');
        is(ref($xml_simple->{curlist}), 'ARRAY', 'curlist is initialized as an array');
        is(ref($xml_simple->{tree}), 'ARRAY', 'tree is initialized as an array');
        is($xml_simple->{opt}->{mode}, 'out', 'handle_options was not called');
    }
}

done_testing();
