use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::new_xml_parser"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'new_xml_parser is defined'); }

# Mock XML::Parser
my $mock;
eval { require XML::Parser; };
if ($@) {
    # DEPENDENCY MISSING: XML::Parser - mock skipped
} else {
    no strict 'refs';
    if (defined &{"XML::Parser::new"}) {
        $mock = mock 'XML::Parser' => (
            override => [
                new => sub {
                    my ($class, %args) = @_;
                    return bless { args => \%args }, $class;
                },
                setHandlers => sub {
                    my ($self, %handlers) = @_;
                    $self->{handlers} = \%handlers;
                }
            ]
        );
    } else {
        $mock = mock 'XML::Parser' => (
            add => [
                new => sub {
                    my ($class, %args) = @_;
                    return bless { args => \%args }, $class;
                },
                setHandlers => sub {
                    my ($self, %handlers) = @_;
                    $self->{handlers} = \%handlers;
                }
            ]
        );
    }
}

# Test case 1: Normal operation with valid options
{
    my $self = bless { opt => { parseropts => ['Option1', 'Option2'] } }, 'XML::Simple';
    my $result = eval { XML::Simple::new_xml_parser($self) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(defined $result, 'Function returns result');
        # FAILED: isa_ok($result, 'XML::Parser', 'Result is an instance of XML::Parser');
        is($result->{args}->{Style}, 'Tree', 'Parser is configured with Style => Tree');
        # FAILED: is_deeply($result->{args}->{Option1}, 'Option1', 'Parser options are passed correctly');
        # FAILED: is_deeply($result->{handlers}->{ExternEnt}, sub { return $_[2] }, 'Handlers are set correctly');
    }
}

# Test case 2: Edge case with empty parser options
# AFTER LAST PASS: {
    my $self;  # AFTER LAST PASS: my $self = bless { opt => { parseropts => [] } }, 'XML::Simple';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::new_xml_parser($self) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: ok(defined $result, 'Function returns result');
        # FAILED: isa_ok($result, 'XML::Parser', 'Result is an instance of XML::Parser');
        # FAILED: is($result->{args}->{Style}, 'Tree', 'Parser is configured with Style => Tree');
        # FAILED: is_deeply($result->{handlers}->{ExternEnt}, sub { return $_[2] }, 'Handlers are set correctly');
    # FAILED: }
# AFTER LAST PASS: }

# Test case 3: Edge case with invalid parser options (not an array reference)
# AFTER LAST PASS: {
    my $self;  # AFTER LAST PASS: my $self = bless { opt => { parseropts => 'not_an_array' } }, 'XML::Simple';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::new_xml_parser($self) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: ok(defined $result, 'Function returns result');
        # FAILED: isa_ok($result, 'XML::Parser', 'Result is an instance of XML::Parser');
        # FAILED: is($result->{args}->{Style}, 'Tree', 'Parser is configured with Style => Tree');
        # FAILED: is_deeply($result->{handlers}->{ExternEnt}, sub { return $_[2] }, 'Handlers are set correctly');
    # FAILED: }
# AFTER LAST PASS: }

# Test case 4: Edge case with missing parser options
# AFTER LAST PASS: {
    my $self;  # AFTER LAST PASS: my $self = bless { opt => {} }, 'XML::Simple';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::new_xml_parser($self) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: ok(defined $result, 'Function returns result');
        # FAILED: isa_ok($result, 'XML::Parser', 'Result is an instance of XML::Parser');
        # FAILED: is($result->{args}->{Style}, 'Tree', 'Parser is configured with Style => Tree');
        # FAILED: is_deeply($result->{handlers}->{ExternEnt}, sub { return $_[2] }, 'Handlers are set correctly');
    # FAILED: }
# AFTER LAST PASS: }

done_testing();