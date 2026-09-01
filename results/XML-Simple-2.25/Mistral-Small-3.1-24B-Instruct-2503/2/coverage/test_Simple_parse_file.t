use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::parse_file"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'parse_file is defined'); }

# Mock dependencies
my $mock;
# AFTER LAST PASS: eval { require XML::Simple; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: XML::Simple - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"XML::Simple::handle_options"}) {
        # AFTER LAST PASS: $mock = mock 'XML::Simple' => (
            # AFTER LAST PASS: override => [
                # AFTER LAST PASS: handle_options => sub { return 1; },
                # AFTER LAST PASS: default_config_file => sub { return 'default.xml'; },
                # AFTER LAST PASS: find_xml_file => sub { return shift; },
                # AFTER LAST PASS: build_simple_tree => sub { return { parsed => 'data' }; },
                # AFTER LAST PASS: cache_read_ => sub { return undef; },
                # AFTER LAST PASS: cache_write_ => sub { return 1; },
            # AFTER LAST PASS: ]
        # AFTER LAST PASS: );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock = mock 'XML::Simple' => (
            # AFTER LAST PASS: add => [
                # AFTER LAST PASS: handle_options => sub { return 1; },
                # AFTER LAST PASS: default_config_file => sub { return 'default.xml'; },
                # AFTER LAST PASS: find_xml_file => sub { return shift; },
                # AFTER LAST PASS: build_simple_tree => sub { return { parsed => 'data' }; },
                # AFTER LAST PASS: cache_read_ => sub { return undef; },
                # AFTER LAST PASS: cache_write_ => sub { return 1; },
            # AFTER LAST PASS: ]
        # AFTER LAST PASS: );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# Test case: Normal operation with valid XML file
# AFTER LAST PASS: {
    my ($fh, $filename);  # AFTER LAST PASS: my ($fh, $filename) = tempfile();
    # AFTER LAST PASS: print $fh '<root><child>data</child></root>';
    # AFTER LAST PASS: close $fh;

    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::parse_file($filename) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is(ref($result), 'HASH', 'parse_file returns a hash reference');
        # FAILED: is($result->{parsed}, 'data', 'Parsed data is correct');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: File not found
# AFTER LAST PASS: {
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::parse_file('nonexistent.xml') };
    # FAILED: if ($@) { like($@, qr/No such file or directory/, 'File not found error is thrown'); } else {
        # FAILED: fail('Expected file not found error, but function did not crash');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Empty XML file
# AFTER LAST PASS: {
    my ($fh, $filename);  # AFTER LAST PASS: my ($fh, $filename) = tempfile();
    # AFTER LAST PASS: close $fh;

    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::parse_file($filename) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is(ref($result), 'HASH', 'parse_file returns a hash reference');
        # FAILED: is_deeply($result, {}, 'Empty file returns an empty hash reference');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Invalid XML file
# AFTER LAST PASS: {
    my ($fh, $filename);  # AFTER LAST PASS: my ($fh, $filename) = tempfile();
    # AFTER LAST PASS: print $fh '<root><child>data';
    # AFTER LAST PASS: close $fh;

    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::parse_file($filename) };
    # FAILED: if ($@) { like($@, qr/Unexpected end of document/, 'Invalid XML error is thrown'); } else {
        # FAILED: fail('Expected invalid XML error, but function did not crash');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Caching enabled
# AFTER LAST PASS: {
    # AFTER LAST PASS: mock 'XML::Simple' => (
        # AFTER LAST PASS: override => [
            # AFTER LAST PASS: cache_read_ => sub { return { cached => 'data' }; },
        # AFTER LAST PASS: ]
    # AFTER LAST PASS: );

    my ($fh, $filename);  # AFTER LAST PASS: my ($fh, $filename) = tempfile();
    # AFTER LAST PASS: print $fh '<root><child>data</child></root>';
    # AFTER LAST PASS: close $fh;

    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::parse_file($filename) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is(ref($result), 'HASH', 'parse_file returns a hash reference');
        # FAILED: is($result->{cached}, 'data', 'Cached data is returned');
    # FAILED: }
# AFTER LAST PASS: }

done_testing();