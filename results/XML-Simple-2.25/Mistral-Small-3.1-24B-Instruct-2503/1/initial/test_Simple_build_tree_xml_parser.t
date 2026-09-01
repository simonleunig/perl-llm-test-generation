use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }  # Use actual module name from package declaration

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::build_tree_xml_parser"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'build_tree_xml_parser is defined'); }

# Mock dependencies
mock 'XML::Parser' => (
    parse => sub {
        my ($self, $fh) = @_;
        return { root => 'parsed' };
    },
    new => sub {
        return bless {}, 'XML::Parser';
    }
);

mock 'Carp' => (
    croak => sub {
        die @_;
    },
    carp => sub {
        warn @_;
    }
);

mock 'File::Basename' => (
    basename => sub {
        return 'basename';
    }
);

mock 'File::Spec' => (
    catfile => sub {
        return 'catfile';
    }
);

# Test case: Valid XML file parsing
{
    my ($fh, $filename) = tempfile();
    print $fh '<root></root>';
    close $fh;

    my $self = bless { opt => {} }, 'XML::Simple';
    my $result = eval { XML::Simple::build_tree_xml_parser($self, $filename) };
    if ($@) { fail('Function crashed: ' . $@); } else { is($result, { root => 'parsed' }, 'Parsed XML file correctly'); }
}

# Test case: Valid XML string parsing
{
    my $xml_string = '<root></root>';
    my $self = bless { opt => {} }, 'XML::Simple';
    my $result = eval { XML::Simple::build_tree_xml_parser($self, undef, \$xml_string) };
    if ($@) { fail('Function crashed: ' . $@); } else { is($result, { root => 'parsed' }, 'Parsed XML string correctly'); }
}

# Test case: Missing XML::Parser module
{
    unmock 'XML::Parser';
    my $self = bless { opt => {} }, 'XML::Simple';
    my $result = eval { XML::Simple::build_tree_xml_parser($self) };
    is($@, "XMLin() requires either XML::SAX or XML::Parser", 'Dies when XML::Parser is not available');
    mock 'XML::Parser' => (
        parse => sub {
            my ($self, $fh) = @_;
            return { root => 'parsed' };
        },
        new => sub {
            return bless {}, 'XML::Parser';
        }
    );
}

# Test case: nsexpand option warning
{
    my $self = bless { opt => { nsexpand => 1 } }, 'XML::Simple';
    my $result = eval { XML::Simple::build_tree_xml_parser($self) };
    like($@, qr/'nsexpand' option requires XML::SAX/, 'Issues warning for nsexpand option');
}

# Test case: File open failure
{
    my $self = bless { opt => {} }, 'XML::Simple';
    my $result = eval { XML::Simple::build_tree_xml_parser($self, 'nonexistent_file.xml') };
    like($@, qr/nonexistent_file\.xml - No such file or directory/, 'Dies when file cannot be opened');
}

# Test case: Malformed XML string
{
    my $xml_string = '<root>';
    my $self = bless { opt => {} }, 'XML::Simple';
    my $result = eval { XML::Simple::build_tree_xml_parser($self, undef, \$xml_string) };
    like($@, qr/Unexpected end of document/, 'Dies when XML string is malformed');
}

done_testing();
