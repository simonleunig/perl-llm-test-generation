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
mock 'Scalar::Util', 'refaddr' => sub { return 1; };
mock 'UNIVERSAL', 'isa' => sub { return 1; };
mock 'XML::Simple', 'escape_value' => sub { return shift; };
mock 'XML::Simple', 'hash_to_array' => sub { return shift; };
mock 'XML::Simple', 'copy_hash' => sub { return shift; };
mock 'XML::Simple', 'new_hashref' => sub { return {}; };
mock 'XML::Simple', 'sorted_keys' => sub { return keys %{shift}; };
mock 'XML::Simple', 'escape_attr' => sub { return shift; };

# Test case 1: Basic hash reference
my $self = bless { opt => { noindent => 0, noescape => 0, keyattr => 0, grouptags => {}, suppressempty => 0, contentkey => '' }, _ancestors => {}, nsup => undef, ns_prefix => 0 }, 'XML::Simple';
my $hash_ref = { key1 => 'value1', key2 => 'value2' };
my $result = eval { $self->value_to_xml($hash_ref, 'root') };
if ($@) { fail('Test case 1 crashed: ' . $@); } else {
    is($result, "<root>\n  <key1>value1</key1>\n  <key2>value2</key2>\n</root>\n", 'Basic hash reference test');
}

# Test case 2: Array reference
my $array_ref = ['value1', 'value2'];
$result = eval { $self->value_to_xml($array_ref, 'root') };
if ($@) { fail('Test case 2 crashed: ' . $@); } else {
    is($result, "<root>\n  <root>value1</root>\n  <root>value2</root>\n</root>\n", 'Array reference test');
}

# Test case 3: Circular reference
my $circular_ref = {};
$circular_ref->{self} = $circular_ref;
$result = eval { $self->value_to_xml($circular_ref, 'root') };
if ($@ !~ /circular data structures not supported/) { fail('Test case 3 did not catch circular reference'); } else {
    pass('Circular reference test');
}

# Test case 4: Undefined value
my $undefined_ref = { key1 => undef };
$result = eval { $self->value_to_xml($undefined_ref, 'root') };
if ($@) { fail('Test case 4 crashed: ' . $@); } else {
    is($result, "<root>\n  <key1></key1>\n</root>\n", 'Undefined value test');
}

# Test case 5: Namespace handling
$self->{nsup} = bless {}, 'XML::NamespaceSupport';
$self->{nsup}->declare_prefix('ns', 'http://example.com');
my $ns_ref = { 'ns:key1' => 'value1' };
$result = eval { $self->value_to_xml($ns_ref, 'root') };
if ($@) { fail('Test case 5 crashed: ' . $@); } else {
    is($result, "<root xmlns:ns=\"http://example.com\">\n  <ns:key1>value1</ns:key1>\n</root>\n", 'Namespace handling test');
}

# Test case 6: No indentation
$self->{opt}->{noindent} = 1;
$result = eval { $self->value_to_xml($hash_ref, 'root') };
if ($@) { fail('Test case 6 crashed: ' . $@); } else {
    is($result, "<root><key1>value1</key1><key2>value2</key2></root>", 'No indentation test');
}

# Test case 7: Suppress empty values
$self->{opt}->{suppressempty} = 1;
$result = eval { $self->value_to_xml($undefined_ref, 'root') };
if ($@) { fail('Test case 7 crashed: ' . $@); } else {
    is($result, "<root></root>\n", 'Suppress empty values test');
}

done_testing();
