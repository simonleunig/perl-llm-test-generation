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
my $self = bless { opt => { noescape => 1, noindent => 1 }, _ancestors => {} }, 'XML::Simple';
my $hash_ref = { key => 'value' };
my $expected_xml = '<key>value</key>';
my $result = eval { $self->value_to_xml($hash_ref, 'key', '') };
if ($@) { fail('Test case 1 crashed: ' . $@); } else { is($result, $expected_xml, 'Basic hash reference test'); }

# Test case 2: Array reference
my $array_ref = ['value1', 'value2'];
$expected_xml = '<key>value1</key><key>value2</key>';
$result = eval { $self->value_to_xml($array_ref, 'key', '') };
if ($@) { fail('Test case 2 crashed: ' . $@); } else { is($result, $expected_xml, 'Array reference test'); }

# Test case 3: Circular reference
my $circular_ref = {};
$circular_ref->{self} = $circular_ref;
$result = eval { $self->value_to_xml($circular_ref, 'key', '') };
if ($@ !~ /circular data structures not supported/) { fail('Test case 3 did not catch circular reference'); } else { pass('Circular reference test'); }

# Test case 4: Undefined value
my $undefined_ref = { key => undef };
$result = eval { $self->value_to_xml($undefined_ref, 'key', '') };
if ($@) { fail('Test case 4 crashed: ' . $@); } else { is($result, '<key></key>', 'Undefined value test'); }

# Test case 5: Suppress empty option
$self->{opt}->{suppressempty} = 1;
$result = eval { $self->value_to_xml($undefined_ref, 'key', '') };
if ($@) { fail('Test case 5 crashed: ' . $@); } else { is($result, '', 'Suppress empty test'); }

# Test case 6: Namespace handling
mock 'XML::NamespaceSupport', 'new' => sub { return bless { push_context => sub {}, pop_context => sub {}, declare_prefix => sub {}, get_uri => sub { return '' }, parse_jclark_notation => sub { return ('', shift) }, get_prefix => sub { return 'ns' } }, 'XML::NamespaceSupport' };
$self->{nsup} = XML::NamespaceSupport->new;
$hash_ref = { 'xmlns:ns' => 'http://example.com', 'ns:key' => 'value' };
$expected_xml = '<key xmlns:ns="http://example.com" ns:key="value"></key>';
$result = eval { $self->value_to_xml($hash_ref, 'key', '') };
if ($@) { fail('Test case 6 crashed: ' . $@); } else { is($result, $expected_xml, 'Namespace handling test'); }

# Test case 7: Mixed content
$hash_ref = { key => 'value', 'another-key' => 'another-value' };
$expected_xml = '<key>value</key><another-key>another-value</another-key>';
$result = eval { $self->value_to_xml($hash_ref, '', '') };
if ($@) { fail('Test case 7 crashed: ' . $@); } else { is($result, $expected_xml, 'Mixed content test'); }

done_testing();
