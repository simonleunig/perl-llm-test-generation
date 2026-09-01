use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::build_tree"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'build_tree is defined'); }

# Mocking dependencies
my $mock;
eval { require XML::SAX::ParserFactory; };
if ($@) {
    # DEPENDENCY MISSING: XML::SAX::ParserFactory - mock skipped
} else {
    no strict 'refs';
    if (defined &{"XML::SAX::ParserFactory::parser"}) {
        $mock = mock 'XML::SAX::ParserFactory' => (
            override => [
                parser => sub {
                    return bless {}, 'Mock::Parser';
                }
            ]
        );
    } else {
        $mock = mock 'XML::SAX::ParserFactory' => (
            add => [
                parser => sub {
                    return bless {}, 'Mock::Parser';
                }
            ]
        );
    }
}

mock 'Mock::Parser' => (
    parse_uri => sub {
        my ($self, $filename) = @_;
        return { filename => $filename };
    },
    parse_file => sub {
        my ($self, $filehandle) = @_;
        return { filehandle => $filehandle };
    },
    parse_string => sub {
        my ($self, $string) = @_;
        return { string => $string };
    }
);

# Test case: Parsing from a filename
{
    my $self = bless {}, 'XML::Simple';
    my $filename = 'test.xml';
    my $result = eval { $self->build_tree($filename) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result->{filename}, $filename, 'Parsing from filename works correctly');
    }
}

# Test case: Parsing from a string
{
    my $self = bless {}, 'XML::Simple';
    my $string = '<?xml version="1.0"?><root></root>';
    my $result = eval { $self->build_tree(undef, \$string) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result->{string}, $string, 'Parsing from string works correctly');
    }
}

# Test case: Parsing from a file handle
{
    my $self = bless {}, 'XML::Simple';
    my ($fh, $filename) = tempfile();
    print $fh '<?xml version="1.0"?><root></root>';
    close $fh;
    my $result = eval { $self->build_tree(undef, $fh) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result->{filehandle}, $fh, 'Parsing from file handle works correctly');
    }
}

# Test case: Fallback to XML::Parser when XML::SAX is not available
{
    mock 'XML::SAX' => (
        parser => sub {
            die "XML::SAX not available";
        }
    );

    my $self = bless {}, 'XML::Simple';
    my $filename = 'test.xml';
    my $result = eval { $self->build_tree($filename) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(defined $result, 'Fallback to XML::Parser works correctly');
    }
}

# Test case: Error when preferred parser is not available
{
    $ENV{XML_SIMPLE_PREFERRED_PARSER} = 'NonExistent::Parser';
    my $self = bless {}, 'XML::Simple';
    my $filename = 'test.xml';
    my $error = eval { $self->build_tree($filename) };
    if ($@) {
        like($@, qr/XMLin\(\) could not load XML::SAX/, 'Error when preferred parser is not available');
    } else {
        fail('Expected error not thrown');
    }
}

# Test case: No filename or string provided
{
    my $self = bless {}, 'XML::Simple';
    my $result = eval { $self->build_tree() };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(!defined $result, 'No filename or string provided returns undef');
    }
}

done_testing();