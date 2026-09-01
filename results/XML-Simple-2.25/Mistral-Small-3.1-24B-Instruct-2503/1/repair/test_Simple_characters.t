use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw(tempfile tempdir);
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::characters"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'characters is defined'); }

# Mocking dependencies
my $mock;
eval { require XML::Simple; };
if ($@) {
    # DEPENDENCY MISSING: XML::Simple - mock skipped
} else {
    no strict 'refs';
    if (defined &{"XML::Simple::new"}) {
        $mock = mock 'XML::Simple' => (
            override => [
                'new' => sub {
                    my $class = shift;
                    return bless { curlist => [] }, $class;
                },
            ],
        );
    } else {
        $mock = mock 'XML::Simple' => (
            add => [
                'new' => sub {
                    my $class = shift;
                    return bless { curlist => [] }, $class;
                },
            ],
        );
    }
}

# Test case 1: Normal operation with existing text node
{
    my $xml_simple = XML::Simple->new();
    my $chars = { Data => 'new text' };
    $xml_simple->{curlist} = [0, 'existing text'];

    my $result = eval { XML::Simple::characters($xml_simple, $chars) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($xml_simple->{curlist}[1], 'existing textnew text', 'Appends text to existing text node');
    }
}

# Test case 2: Normal operation with new text node
{
    my $xml_simple = XML::Simple->new();
    my $chars = { Data => 'new text' };

    my $result = eval { XML::Simple::characters($xml_simple, $chars) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($xml_simple->{curlist}[0], 'new text', 'Creates new text node');
    }
}

# Test case 3: Edge case with empty character data
{
    my $xml_simple = XML::Simple->new();
    my $chars = { Data => '' };

    my $result = eval { XML::Simple::characters($xml_simple, $chars) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is_deeply($xml_simple->{curlist}, [], 'Does not modify internal state with empty character data');
    }
}

# Test case 4: Edge case with no existing text node
{
    my $xml_simple = XML::Simple->new();
    my $chars = { Data => 'new text' };
    $xml_simple->{curlist} = [0];

    my $result = eval { XML::Simple::characters($xml_simple, $chars) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($xml_simple->{curlist}[1], 'new text', 'Creates new text node when none exists');
    }
}

done_testing();