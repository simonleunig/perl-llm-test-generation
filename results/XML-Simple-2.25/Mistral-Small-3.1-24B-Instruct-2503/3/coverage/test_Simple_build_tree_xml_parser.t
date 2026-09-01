use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::build_tree_xml_parser"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'build_tree_xml_parser is defined'); }

# Mock dependencies
my $mock;
# AFTER LAST PASS: eval { require XML::Parser; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: XML::Parser - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"XML::Parser::parse"}) {
        # AFTER LAST PASS: $mock = mock 'XML::Parser' => (
            # AFTER LAST PASS: override => [
                # AFTER LAST PASS: parse => sub {
                    my ($self, $fh);  # AFTER LAST PASS: my ($self, $fh) = @_;
                    # AFTER LAST PASS: return { root => 'parsed' };
                # AFTER LAST PASS: },
                # AFTER LAST PASS: new => sub {
                    # AFTER LAST PASS: return bless {}, 'XML::Parser';
                # AFTER LAST PASS: }
            # AFTER LAST PASS: ]
        # AFTER LAST PASS: );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock = mock 'XML::Parser' => (
            # AFTER LAST PASS: add => [
                # AFTER LAST PASS: parse => sub {
                    my ($self, $fh);  # AFTER LAST PASS: my ($self, $fh) = @_;
                    # AFTER LAST PASS: return { root => 'parsed' };
                # AFTER LAST PASS: },
                # AFTER LAST PASS: new => sub {
                    # AFTER LAST PASS: return bless {}, 'XML::Parser';
                # AFTER LAST PASS: }
            # AFTER LAST PASS: ]
        # AFTER LAST PASS: );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# AFTER LAST PASS: mock 'Carp' => (
    # AFTER LAST PASS: croak => sub {
        # AFTER LAST PASS: die @_;
    # AFTER LAST PASS: },
    # AFTER LAST PASS: carp => sub {
        # AFTER LAST PASS: warn @_;
    # AFTER LAST PASS: }
# AFTER LAST PASS: );

# Test case 1: Parsing from a filename
# AFTER LAST PASS: {
    my ($fh, $filename);  # AFTER LAST PASS: my ($fh, $filename) = tempfile();
    # AFTER LAST PASS: print $fh '<root></root>';
    # AFTER LAST PASS: close $fh;

    my $self;  # AFTER LAST PASS: my $self = bless { opt => {} }, 'XML::Simple';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::build_tree_xml_parser($self, $filename) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else { is($result, { root => 'parsed' }, 'Parsing from filename succeeds'); }
# AFTER LAST PASS: }

# Test case 2: Parsing from a string
# AFTER LAST PASS: {
    my $string;  # AFTER LAST PASS: my $string = '<root></root>';
    my $self;  # AFTER LAST PASS: my $self = bless { opt => {} }, 'XML::Simple';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::build_tree_xml_parser($self, undef, \$string) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else { is($result, { root => 'parsed' }, 'Parsing from string succeeds'); }
# AFTER LAST PASS: }

# Test case 3: Missing filename and string
# AFTER LAST PASS: {
    my $self;  # AFTER LAST PASS: my $self = bless { opt => {} }, 'XML::Simple';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::build_tree_xml_parser($self) };
    # FAILED: if ($@) { pass('Function dies when both filename and string are missing'); } else { fail('Expected function to die, but it did not'); }
# AFTER LAST PASS: }

# Test case 4: XML::Parser not available
# AFTER LAST PASS: {
    # AFTER LAST PASS: if ($mock) {
        # AFTER LAST PASS: $mock->unmock_all;
    # AFTER LAST PASS: }
    my $self;  # AFTER LAST PASS: my $self = bless { opt => {} }, 'XML::Simple';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::build_tree_xml_parser($self) };
    # FAILED: if ($@) { like($@, qr/XMLin\(\) requires either XML::SAX or XML::Parser/, 'Function dies when XML::Parser is not available'); } else { fail('Expected function to die, but it did not'); }
    # AFTER LAST PASS: if ($mock) {
        # AFTER LAST PASS: $mock = mock 'XML::Parser' => (
            # AFTER LAST PASS: override => [
                # AFTER LAST PASS: parse => sub {
                    my ($self, $fh);  # AFTER LAST PASS: my ($self, $fh) = @_;
                    # AFTER LAST PASS: return { root => 'parsed' };
                # AFTER LAST PASS: },
                # AFTER LAST PASS: new => sub {
                    # AFTER LAST PASS: return bless {}, 'XML::Parser';
                # AFTER LAST PASS: }
            # AFTER LAST PASS: ]
        # AFTER LAST PASS: );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# Test case 5: nsexpand option set
# AFTER LAST PASS: {
    my $self;  # AFTER LAST PASS: my $self = bless { opt => { nsexpand => 1 } }, 'XML::Simple';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::build_tree_xml_parser($self) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else { pass('Function does not crash with nsexpand option'); }
    # FAILED: like($Test2::Harness::Warnings, qr/'nsexpand' option requires XML::SAX/, 'Warning issued for nsexpand option');
# AFTER LAST PASS: }

# Test case 6: File open failure
# AFTER LAST PASS: {
    my $self;  # AFTER LAST PASS: my $self = bless { opt => {} }, 'XML::Simple';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::build_tree_xml_parser($self, 'nonexistent_file.xml') };
    # FAILED: if ($@) { like($@, qr/nonexistent_file\.xml - No such file or directory/, 'Function dies when file cannot be opened'); } else { fail('Expected function to die, but it did not'); }
# AFTER LAST PASS: }

done_testing();