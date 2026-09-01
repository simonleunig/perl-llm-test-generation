use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }  # Use actual module name from package declaration

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::new_xml_parser"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'new_xml_parser is defined'); }

# Mock XML::Parser
mock 'XML::Parser' => (
    new => sub {
        my ($class, %args) = @_;
        return bless { args => \%args }, $class;
    },
    setHandlers => sub {
        my ($self, %handlers) = @_;
        $self->{handlers} = \%handlers;
    }
);

# Test case 1: Normal operation with valid options
{
    my $self = bless { opt => { parseropts => ['Option1', 'Option2'] } }, 'XML::Simple';
    my $result = eval { XML::Simple::new_xml_parser($self) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(defined $result, 'Function returns result');
        isa_ok($result, 'XML::Parser', 'Result is an instance of XML::Parser');
        is($result->{args}->{Style}, 'Tree', 'Parser is configured with Style => Tree');
        is_deeply($result->{args}->{Option1}, 'Option1', 'Parser options are passed correctly');
        is_deeply($result->{handlers}->{ExternEnt}, sub { return $_[2] }, 'Handlers are set correctly');
    }
}

# Test case 2: Edge case with empty parser options
{
    my $self = bless { opt => { parseropts => [] } }, 'XML::Simple';
    my $result = eval { XML::Simple::new_xml_parser($self) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(defined $result, 'Function returns result');
        isa_ok($result, 'XML::Parser', 'Result is an instance of XML::Parser');
        is($result->{args}->{Style}, 'Tree', 'Parser is configured with Style => Tree');
        is_deeply($result->{handlers}->{ExternEnt}, sub { return $_[2] }, 'Handlers are set correctly');
    }
}

# Test case 3: Edge case with invalid parser options (not an array reference)
{
    my $self = bless { opt => { parseropts => 'not_an_array' } }, 'XML::Simple';
    my $result = eval { XML::Simple::new_xml_parser($self) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(defined $result, 'Function returns result');
        isa_ok($result, 'XML::Parser', 'Result is an instance of XML::Parser');
        is($result->{args}->{Style}, 'Tree', 'Parser is configured with Style => Tree');
        is_deeply($result->{handlers}->{ExternEnt}, sub { return $_[2] }, 'Handlers are set correctly');
    }
}

# Test case 4: Edge case with missing parser options
{
    my $self = bless { opt => {} }, 'XML::Simple';
    my $result = eval { XML::Simple::new_xml_parser($self) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(defined $result, 'Function returns result');
        isa_ok($result, 'XML::Parser', 'Result is an instance of XML::Parser');
        is($result->{args}->{Style}, 'Tree', 'Parser is configured with Style => Tree');
        is_deeply($result->{handlers}->{ExternEnt}, sub { return $_[2] }, 'Handlers are set correctly');
    }
}

done_testing();
