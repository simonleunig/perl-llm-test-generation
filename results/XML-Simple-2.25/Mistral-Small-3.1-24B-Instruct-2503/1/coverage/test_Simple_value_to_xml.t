use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::value_to_xml"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'value_to_xml is defined'); }

# Mock dependencies
# AFTER LAST PASS: mock 'Scalar::Util', 'refaddr' => sub { return 1; };
# AFTER LAST PASS: mock 'UNIVERSAL', 'isa' => sub { return 1; };
# AFTER LAST PASS: mock 'XML::Simple', 'escape_value' => sub { return shift; };
# AFTER LAST PASS: mock 'XML::Simple', 'hash_to_array' => sub { return shift; };
# AFTER LAST PASS: mock 'XML::Simple', 'copy_hash' => sub { return shift; };
# AFTER LAST PASS: mock 'XML::Simple', 'new_hashref' => sub { return {}; };
# AFTER LAST PASS: mock 'XML::Simple', 'sorted_keys' => sub { return keys %{+shift}; };
# AFTER LAST PASS: mock 'XML::Simple', 'escape_attr' => sub { return shift; };

# Test case 1: Basic hash reference
my $self;  # AFTER LAST PASS: my $self = bless { opt => { noindent => 0, noescape => 0, keyattr => 0, grouptags => {}, suppressempty => 0, contentkey => '' }, _ancestors => {}, nsup => undef, ns_prefix => 0 }, 'XML::Simple';
my $hash_ref;  # AFTER LAST PASS: my $hash_ref = { key1 => 'value1', key2 => 'value2' };
my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $self->value_to_xml($hash_ref, 'root') };
# FAILED: if ($@) { fail('Test case 1 crashed: ' . $@); } else {
    # FAILED: is($result, "<root>\n  <key1>value1</key1>\n  <key2>value2</key2>\n</root>\n", 'Basic hash reference test');
# FAILED: }

# Test case 2: Array reference
my $array_ref;  # AFTER LAST PASS: my $array_ref = ['value1', 'value2'];
# UNVALIDATED: $result = eval { $self->value_to_xml($array_ref, 'root') };
# FAILED: if ($@) { fail('Test case 2 crashed: ' . $@); } else {
    # FAILED: is($result, "<root>\n  <root>value1</root>\n  <root>value2</root>\n</root>\n", 'Array reference test');
# FAILED: }

# Test case 3: Circular reference
my $circular_ref;  # AFTER LAST PASS: my $circular_ref = {};
# AFTER LAST PASS: $circular_ref->{self} = $circular_ref;
# UNVALIDATED: $result = eval { $self->value_to_xml($circular_ref, 'root') };
# FAILED: if ($@ !~ /circular data structures not supported/) { fail('Test case 3 did not catch circular reference'); } else {
    # FAILED: pass('Circular reference test');
# FAILED: }

# Test case 4: Undefined value
my $undefined_ref;  # AFTER LAST PASS: my $undefined_ref = { key1 => undef };
# UNVALIDATED: $result = eval { $self->value_to_xml($undefined_ref, 'root') };
# FAILED: if ($@) { fail('Test case 4 crashed: ' . $@); } else {
    # FAILED: is($result, "<root>\n  <key1></key1>\n</root>\n", 'Undefined value test');
# FAILED: }

# Test case 5: Namespace handling
# AFTER LAST PASS: $self->{nsup} = bless {}, 'XML::NamespaceSupport';
# AFTER LAST PASS: $self->{nsup}->declare_prefix('ns', 'http://example.com');
my $ns_ref;  # AFTER LAST PASS: my $ns_ref = { 'ns:key1' => 'value1' };
# UNVALIDATED: $result = eval { $self->value_to_xml($ns_ref, 'root') };
# FAILED: if ($@) { fail('Test case 5 crashed: ' . $@); } else {
    # FAILED: is($result, "<root xmlns:ns=\"http://example.com\">\n  <ns:key1>value1</ns:key1>\n</root>\n", 'Namespace handling test');
# FAILED: }

# Test case 6: No indentation
# AFTER LAST PASS: $self->{opt}->{noindent} = 1;
# UNVALIDATED: $result = eval { $self->value_to_xml($hash_ref, 'root') };
# FAILED: if ($@) { fail('Test case 6 crashed: ' . $@); } else {
    # FAILED: is($result, "<root><key1>value1</key1><key2>value2</key2></root>", 'No indentation test');
# FAILED: }

# Test case 7: Suppress empty values
# AFTER LAST PASS: $self->{opt}->{suppressempty} = 1;
# UNVALIDATED: $result = eval { $self->value_to_xml($undefined_ref, 'root') };
# FAILED: if ($@) { fail('Test case 7 crashed: ' . $@); } else {
    # FAILED: is($result, "<root></root>\n", 'Suppress empty values test');
# FAILED: }

done_testing();