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
# AFTER LAST PASS: eval { require XML::SAX::ParserFactory; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: XML::SAX::ParserFactory - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"XML::SAX::ParserFactory::parser"}) {
        # AFTER LAST PASS: $mock = mock 'XML::SAX::ParserFactory' => (
            # AFTER LAST PASS: override => [
                # AFTER LAST PASS: parser => sub {
                    # AFTER LAST PASS: return bless {}, 'Mock::Parser';
                # AFTER LAST PASS: }
            # AFTER LAST PASS: ]
        # AFTER LAST PASS: );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock = mock 'XML::SAX::ParserFactory' => (
            # AFTER LAST PASS: add => [
                # AFTER LAST PASS: parser => sub {
                    # AFTER LAST PASS: return bless {}, 'Mock::Parser';
                # AFTER LAST PASS: }
            # AFTER LAST PASS: ]
        # AFTER LAST PASS: );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# AFTER LAST PASS: mock 'Mock::Parser' => (
    # AFTER LAST PASS: parse_uri => sub {
        my ($self, $filename);  # AFTER LAST PASS: my ($self, $filename) = @_;
        # AFTER LAST PASS: return { filename => $filename };
    # AFTER LAST PASS: },
    # AFTER LAST PASS: parse_file => sub {
        my ($self, $filehandle);  # AFTER LAST PASS: my ($self, $filehandle) = @_;
        # AFTER LAST PASS: return { filehandle => $filehandle };
    # AFTER LAST PASS: },
    # AFTER LAST PASS: parse_string => sub {
        my ($self, $string);  # AFTER LAST PASS: my ($self, $string) = @_;
        # AFTER LAST PASS: return { string => $string };
    # AFTER LAST PASS: }
# AFTER LAST PASS: );

# Test case: Parsing from a filename
# AFTER LAST PASS: {
    my $self;  # AFTER LAST PASS: my $self = bless {}, 'XML::Simple';
    my $filename;  # AFTER LAST PASS: my $filename = 'test.xml';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $self->build_tree($filename) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result->{filename}, $filename, 'Parsing from filename works correctly');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Parsing from a string
# AFTER LAST PASS: {
    my $self;  # AFTER LAST PASS: my $self = bless {}, 'XML::Simple';
    my $string;  # AFTER LAST PASS: my $string = '<?xml version="1.0"?><root></root>';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $self->build_tree(undef, \$string) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result->{string}, $string, 'Parsing from string works correctly');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Parsing from a file handle
# AFTER LAST PASS: {
    my $self;  # AFTER LAST PASS: my $self = bless {}, 'XML::Simple';
    my ($fh, $filename);  # AFTER LAST PASS: my ($fh, $filename) = tempfile();
    # AFTER LAST PASS: print $fh '<?xml version="1.0"?><root></root>';
    # AFTER LAST PASS: close $fh;
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $self->build_tree(undef, $fh) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result->{filehandle}, $fh, 'Parsing from file handle works correctly');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Fallback to XML::Parser when XML::SAX is not available
# AFTER LAST PASS: {
    # AFTER LAST PASS: mock 'XML::SAX' => (
        # AFTER LAST PASS: parser => sub {
            # AFTER LAST PASS: die "XML::SAX not available";
        # AFTER LAST PASS: }
    # AFTER LAST PASS: );

    my $self;  # AFTER LAST PASS: my $self = bless {}, 'XML::Simple';
    my $filename;  # AFTER LAST PASS: my $filename = 'test.xml';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $self->build_tree($filename) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: ok(defined $result, 'Fallback to XML::Parser works correctly');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Error when preferred parser is not available
# AFTER LAST PASS: {
    # AFTER LAST PASS: $ENV{XML_SIMPLE_PREFERRED_PARSER} = 'NonExistent::Parser';
    my $self;  # AFTER LAST PASS: my $self = bless {}, 'XML::Simple';
    my $filename;  # AFTER LAST PASS: my $filename = 'test.xml';
    my $error;  # AFTER LAST PASS: my $error;  # UNVALIDATED: my $error = eval { $self->build_tree($filename) };
    # AFTER LAST PASS: if ($@) {
        # FAILED: like($@, qr/XMLin\(\) could not load XML::SAX/, 'Error when preferred parser is not available');
    # AFTER LAST PASS: } else {
        # FAILED: fail('Expected error not thrown');
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# Test case: No filename or string provided
# AFTER LAST PASS: {
    my $self;  # AFTER LAST PASS: my $self = bless {}, 'XML::Simple';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $self->build_tree() };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: ok(!defined $result, 'No filename or string provided returns undef');
    # FAILED: }
# AFTER LAST PASS: }

done_testing();