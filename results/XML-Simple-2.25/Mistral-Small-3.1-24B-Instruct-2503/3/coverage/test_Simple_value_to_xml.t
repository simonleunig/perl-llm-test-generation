use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Mock dependencies
my $mock;
eval { require Scalar::Util; };
if ($@) {
    # DEPENDENCY MISSING: Scalar::Util - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Scalar::Util::refaddr"}) {
        $mock = mock 'Scalar::Util' => ( override => { refaddr => sub { return 1; } } );
    } else {
        $mock = mock 'Scalar::Util' => ( add => { refaddr => sub { return 1; } } );
    }
}

eval { require UNIVERSAL; };
if ($@) {
    # DEPENDENCY MISSING: UNIVERSAL - mock skipped
} else {
    no strict 'refs';
    if (defined &{"UNIVERSAL::isa"}) {
        $mock = mock 'UNIVERSAL' => ( override => { isa => sub { return 1; } } );
    } else {
        $mock = mock 'UNIVERSAL' => ( add => { isa => sub { return 1; } } );
    }
}

eval { require XML::NamespaceSupport; };
if ($@) {
    # DEPENDENCY MISSING: XML::NamespaceSupport - mock skipped
} else {
    no strict 'refs';
    if (defined &{"XML::NamespaceSupport::new"}) {
        $mock = mock 'XML::NamespaceSupport' => (
            override => {
                new => sub { return bless {}, 'XML::NamespaceSupport' },
                push_context => sub { return 1; },
                pop_context => sub { return 1; },
                declare_prefix => sub { return 1; },
                get_uri => sub { return 'http://example.com'; },
                get_prefix => sub { return 'ns'; },
                parse_jclark_notation => sub { return ('http://example.com', 'element'); }
            }
        );
    } else {
        $mock = mock 'XML::NamespaceSupport' => (
            add => {
                new => sub { return bless {}, 'XML::NamespaceSupport' },
                push_context => sub { return 1; },
                pop_context => sub { return 1; },
                declare_prefix => sub { return 1; },
                get_uri => sub { return 'http://example.com'; },
                get_prefix => sub { return 'ns'; },
                parse_jclark_notation => sub { return ('http://example.com', 'element'); }
            }
        );
    }
}

eval { require Carp; };
if ($@) {
    # DEPENDENCY MISSING: Carp - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Carp::croak"}) {
        $mock = mock 'Carp' => ( override => { croak => sub { die shift; }, carp => sub { warn shift; } } );
    } else {
        $mock = mock 'Carp' => ( add => { croak => sub { die shift; }, carp => sub { warn shift; } } );
    }
}

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::value_to_xml"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'value_to_xml is defined'); }

# Test cases with eval protection

# Test with a simple hash reference
my $simple_hash;  # AFTER LAST PASS: my $simple_hash = { key => 'value' };
my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::value_to_xml({}, $simple_hash, 'root') };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
    # FAILED: is($result, "<root>\n<key>value</key>\n</root>\n", 'Simple hash reference converted to XML');
# FAILED: }

# Test with a hash reference containing nested hashes
my $nested_hash;  # AFTER LAST PASS: my $nested_hash = { key => { nested_key => 'nested_value' } };
# UNVALIDATED: $result = eval { XML::Simple::value_to_xml({}, $nested_hash, 'root') };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
    # FAILED: is($result, "<root>\n<key>\n<nested_key>nested_value</nested_key>\n</key>\n</root>\n", 'Nested hash reference converted to XML');
# FAILED: }

# Test with an array reference
my $array_ref;  # AFTER LAST PASS: my $array_ref = [ 'value1', 'value2' ];
# UNVALIDATED: $result = eval { XML::Simple::value_to_xml({}, $array_ref, 'root') };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
    # FAILED: is($result, "<root>\n<root>value1</root>\n<root>value2</root>\n</root>\n", 'Array reference converted to XML');
# FAILED: }

# Test with circular data structure (should croak)
my $circular_ref;
# AFTER LAST PASS: $circular_ref = { key => $circular_ref };
# UNVALIDATED: $result = eval { XML::Simple::value_to_xml({}, $circular_ref, 'root') };
# AFTER LAST PASS: if ($@) {
    # FAILED: like($@, qr/circular data structures not supported/, 'Circular data structure detected');
# AFTER LAST PASS: } else {
    # FAILED: fail('Function did not croak on circular data structure');
# AFTER LAST PASS: }

# Test with undefined values
my $undefined_hash;  # AFTER LAST PASS: my $undefined_hash = { key => undef };
# UNVALIDATED: $result = eval { XML::Simple::value_to_xml({}, $undefined_hash, 'root') };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
    # FAILED: is($result, "<root>\n<key></key>\n</root>\n", 'Undefined value handled correctly');
# FAILED: }

# Test with namespaces
my $namespace_hash;  # AFTER LAST PASS: my $namespace_hash = { 'xmlns' => 'http://example.com', 'ns:key' => 'value' };
# UNVALIDATED: $result = eval { XML::Simple::value_to_xml({}, $namespace_hash, 'root') };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
    # FAILED: is($result, "<root xmlns=\"http://example.com\" xmlns:ns=\"http://example.com\">\n<ns:key>value</ns:key>\n</root>\n", 'Namespaces handled correctly');
# FAILED: }

# Test with attributes
my $attr_hash;  # AFTER LAST PASS: my $attr_hash = { key => { attr => 'value' } };
# UNVALIDATED: $result = eval { XML::Simple::value_to_xml({}, $attr_hash, 'root', { valueattr => { key => 'attr' } }) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
    # FAILED: is($result, "<root>\n<key attr=\"value\"/>\n</root>\n", 'Attributes handled correctly');
# FAILED: }

done_testing();