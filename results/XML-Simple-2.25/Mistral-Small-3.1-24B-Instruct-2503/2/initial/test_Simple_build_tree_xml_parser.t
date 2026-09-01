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

# Test case 1: Parsing from a filename
{
    my ($fh, $filename) = tempfile();
    print $fh '<root></root>';
    close $fh;

    my $self = bless { opt => {} }, 'XML::Simple';
    my $result = eval { XML::Simple::build_tree_xml_parser($self, $filename) };
    if ($@) { fail('Function crashed: ' . $@); } else { is($result, { root => 'parsed' }, 'Parsing from filename succeeds'); }
}

# Test case 2: Parsing from a string
{
    my $string = '<root></root>';
    my $self = bless { opt => {} }, 'XML::Simple';
    my $result = eval { XML::Simple::build_tree_xml_parser($self, undef, \$string) };
    if ($@) { fail('Function crashed: ' . $@); } else { is($result, { root => 'parsed' }, 'Parsing from string succeeds'); }
}

# Test case 3: Missing filename and string
{
    my $self = bless { opt => {} }, 'XML::Simple';
    my $result = eval { XML::Simple::build_tree_xml_parser($self) };
    if ($@) { fail('Function crashed: ' . $@); } else { fail('Expected function to die, but it did not'); }
}

# Test case 4: XML::Parser not available
{
    unmock 'XML::Parser';
    my $self = bless { opt => {} }, 'XML::Simple';
    my $result = eval { XML::Simple::build_tree_xml_parser($self) };
    if ($@) { like($@, qr/XMLin\(\) requires either XML::SAX or XML::Parser/, 'Function dies when XML::Parser is not available'); } else { fail('Expected function to die, but it did not'); }
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

# Test case 5: nsexpand option set
{
    my $self = bless { opt => { nsexpand => 1 } }, 'XML::Simple';
    my $result = eval { XML::Simple::build_tree_xml_parser($self) };
    if ($@) { fail('Function crashed: ' . $@); } else { pass('Function does not crash with nsexpand option'); }
    like($Test2::Harness::Warnings, qr/'nsexpand' option requires XML::SAX/, 'Warning issued for nsexpand option');
}

# Test case 6: File open failure
{
    my $self = bless { opt => {} }, 'XML::Simple';
    my $result = eval { XML::Simple::build_tree_xml_parser($self, 'nonexistent_file.xml') };
    if ($@) { like($@, qr/nonexistent_file\.xml - No such file or directory/, 'Function dies when file cannot be opened'); } else { fail('Expected function to die, but it did not'); }
}

done_testing();
