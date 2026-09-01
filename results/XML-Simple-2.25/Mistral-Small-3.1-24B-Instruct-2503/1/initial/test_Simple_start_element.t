use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }  # Use actual module name from package declaration

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::start_element"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'start_element is defined'); }

# Mocking the XML::Simple object
my $mock_self = {
    opt => { nsexpand => 0 },
    lists => [],
    curlist => [],
};

# Test case 1: Basic element with no attributes
my $element1 = {
    Name => 'element',
    Attributes => {},
};
my $result1 = eval {
    XML::Simple::start_element($mock_self, $element1);
};
if ($@) { fail('Function crashed: ' . $@); } else {
    is($mock_self->{lists}[0], $mock_self->{curlist}, 'lists should contain the initial curlist');
    is($mock_self->{curlist}[0], 'element', 'curlist should contain the element name');
    is($mock_self->{curlist}[1], [{}], 'curlist should contain the attributes hash');
}

# Test case 2: Element with attributes
my $element2 = {
    Name => 'element',
    Attributes => {
        attr1 => { Name => 'attr1', Value => 'value1' },
        attr2 => { Name => 'attr2', Value => 'value2' },
    },
};
my $result2 = eval {
    XML::Simple::start_element($mock_self, $element2);
};
if ($@) { fail('Function crashed: ' . $@); } else {
    is($mock_self->{lists}[1], $mock_self->{curlist}, 'lists should contain the updated curlist');
    is($mock_self->{curlist}[0], 'element', 'curlist should contain the element name');
    is($mock_self->{curlist}[1], [{ attr1 => 'value1', attr2 => 'value2' }], 'curlist should contain the attributes hash');
}

# Test case 3: Element with namespace expansion
$mock_self->{opt}->{nsexpand} = 1;
my $element3 = {
    Name => 'element',
    LocalName => 'localElement',
    NamespaceURI => 'http://example.com',
    Attributes => {
        attr1 => { LocalName => 'localAttr1', NamespaceURI => 'http://example.com', Value => 'value1' },
        attr2 => { LocalName => 'localAttr2', NamespaceURI => 'http://example.com', Value => 'value2' },
    },
};
my $result3 = eval {
    XML::Simple::start_element($mock_self, $element3);
};
if ($@) { fail('Function crashed: ' . $@); } else {
    is($mock_self->{lists}[2], $mock_self->{curlist}, 'lists should contain the updated curlist');
    is($mock_self->{curlist}[0], '{http://example.com}localElement', 'curlist should contain the expanded element name');
    is($mock_self->{curlist}[1], [{ '{http://example.com}localAttr1' => 'value1', '{http://example.com}localAttr2' => 'value2' }], 'curlist should contain the expanded attributes hash');
}

# Test case 4: Element with undefined attributes
my $element4 = {
    Name => 'element',
    Attributes => undef,
};
my $result4 = eval {
    XML::Simple::start_element($mock_self, $element4);
};
if ($@) { fail('Function crashed: ' . $@); } else {
    is($mock_self->{lists}[3], $mock_self->{curlist}, 'lists should contain the updated curlist');
    is($mock_self->{curlist}[0], 'element', 'curlist should contain the element name');
    is($mock_self->{curlist}[1], [{}], 'curlist should contain an empty attributes hash');
}

done_testing();
