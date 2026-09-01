use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::set_var"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'set_var is defined'); }

# Mock the XML::Simple object
my $mock_xml_simple = mock('XML::Simple', override => {
    _var_values => { %{} }
});

# Test case 1: Setting a valid variable
my $result = eval {
    XML::Simple::set_var($mock_xml_simple, 'var_name', 'var_value');
};
if ($@) {
    fail('Function crashed: ' . $@);
} else {
    ok(defined $result, 'Function returns result');
    is($mock_xml_simple->{_var_values}{'var_name'}, 'var_value', 'Variable set correctly');
}

# Test case 2: Setting a variable with undef value
$result = eval {
    XML::Simple::set_var($mock_xml_simple, 'var_name', undef);
};
if ($@) {
    fail('Function crashed: ' . $@);
} else {
    ok(defined $result, 'Function returns result');
    is($mock_xml_simple->{_var_values}{'var_name'}, undef, 'Variable set to undef correctly');
}

# Test case 3: Setting a variable with an empty string value
$result = eval {
    XML::Simple::set_var($mock_xml_simple, 'var_name', '');
};
if ($@) {
    fail('Function crashed: ' . $@);
} else {
    ok(defined $result, 'Function returns result');
    is($mock_xml_simple->{_var_values}{'var_name'}, '', 'Variable set to empty string correctly');
}

# Test case 4: Setting a variable with a numeric value
$result = eval {
    XML::Simple::set_var($mock_xml_simple, 'var_name', 123);
};
if ($@) {
    fail('Function crashed: ' . $@);
} else {
    ok(defined $result, 'Function returns result');
    is($mock_xml_simple->{_var_values}{'var_name'}, 123, 'Variable set to numeric value correctly');
}

# Test case 5: Setting a variable with a complex data structure
$result = eval {
    XML::Simple::set_var($mock_xml_simple, 'var_name', { key => 'value' });
};
if ($@) {
    fail('Function crashed: ' . $@);
} else {
    ok(defined $result, 'Function returns result');
    is_deeply($mock_xml_simple->{_var_values}{'var_name'}, { key => 'value' }, 'Variable set to complex data structure correctly');
}

done_testing();