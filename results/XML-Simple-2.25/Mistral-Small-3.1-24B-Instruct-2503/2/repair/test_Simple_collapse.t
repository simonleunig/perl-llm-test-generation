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
eval { require XML::Simple; };
if ($@) {
    # DEPENDENCY MISSING: XML::Simple - mock skipped
} else {
    no strict 'refs';
    if (defined &{"XML::Simple::new_hashref"}) {
        $mock = mock 'XML::Simple' => (
            override => [
                new_hashref => sub { return {} },
                normalise_space => sub { return shift },
                get_var => sub { return 'mocked_var' },
                set_var => sub { return 1 },
                array_to_hash => sub { return { key => 'value' } },
            ]
        );
    } else {
        $mock = mock 'XML::Simple' => (
            add => [
                new_hashref => sub { return {} },
                normalise_space => sub { return shift },
                get_var => sub { return 'mocked_var' },
                set_var => sub { return 1 },
                array_to_hash => sub { return { key => 'value' } },
            ]
        );
    }
}

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::collapse"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'collapse is defined'); }

# Test case 1: Basic functionality with no options
my $self = bless { opt => {}, _var_values => {} }, 'XML::Simple';
my $attr = { key => 'value' };
my $result = eval { XML::Simple::collapse($self, $attr) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, $attr, 'Basic functionality with no options'); }

# Test case 2: Discard attributes if 'noattr' is set
$self = bless { opt => { noattr => 1 }, _var_values => {} }, 'XML::Simple';
$result = eval { XML::Simple::collapse($self, $attr) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, {}, 'Discard attributes if noattr is set'); }

# Test case 3: Normalize space if 'normalisespace' is set to 2
$self = bless { opt => { normalisespace => 2 }, _var_values => {} }, 'XML::Simple';
$attr = { key => '  value  ' };
$result = eval { XML::Simple::collapse($self, $attr) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result->{key}, 'value', 'Normalize space if normalisespace is set to 2'); }

# Test case 4: Variable substitutions
$self = bless { opt => {}, _var_values => { var => 'value' } }, 'XML::Simple';
$attr = { key => '${var}' };
$result = eval { XML::Simple::collapse($self, $attr) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result->{key}, 'mocked_var', 'Variable substitutions'); }

# Test case 5: Roll up 'value' attributes
$self = bless { opt => { valueattrlist => { key => 1 } }, _var_values => {} }, 'XML::Simple';
$attr = { key => 'value' };
$result = eval { XML::Simple::collapse($self, $attr) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'value', 'Roll up value attributes'); }

# Test case 6: Add nested elements
$self = bless { opt => {}, _var_values => {} }, 'XML::Simple';
$attr = { key => 'value' };
$result = eval { XML::Simple::collapse($self, $attr, 'nested_key', 'nested_value') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result->{nested_key}, 'nested_value', 'Add nested elements'); }

# Test case 7: Combine duplicate attributes into arrayref
$self = bless { opt => {}, _var_values => {} }, 'XML::Simple';
$attr = { key => 'value' };
$result = eval { XML::Simple::collapse($self, $attr, 'key', 'another_value') };
if ($@) { fail('Function crashed: ' . $@); } else { is_deeply($result->{key}, ['value', 'another_value'], 'Combine duplicate attributes into arrayref'); }

# Test case 8: Turn arrayrefs into hashrefs if key fields present
$self = bless { opt => { keyattr => 1 }, _var_values => {} }, 'XML::Simple';
$attr = { key => ['value1', 'value2'] };
$result = eval { XML::Simple::collapse($self, $attr) };
if ($@) { fail('Function crashed: ' . $@); } else { is_deeply($result->{key}, { key => 'value' }, 'Turn arrayrefs into hashrefs if key fields present'); }

# Test case 9: Disintermediate grouped tags
$self = bless { opt => { grouptags => { key => 'child_key' } }, _var_values => {} }, 'XML::Simple';
$attr = { key => { child_key => 'value' } };
$result = eval { XML::Simple::collapse($self, $attr) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result->{key}, 'value', 'Disintermediate grouped tags'); }

# Test case 10: Fold hashes containing a single anonymous array up into just the array
$self = bless { opt => { suppressempty => '' }, _var_values => {} }, 'XML::Simple';
$attr = { anon => ['value'] };
$result = eval { XML::Simple::collapse($self, $attr) };
if ($@) { fail('Function crashed: ' . $@); } else { is_deeply($result, ['value'], 'Fold hashes containing a single anonymous array up into just the array'); }

# Test case 11: Handle empty elements
$self = bless { opt => { suppressempty => '' }, _var_values => {} }, 'XML::Simple';
$attr = {};
$result = eval { XML::Simple::collapse($self, $attr) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, '', 'Handle empty elements'); }

# Test case 12: Handle elements with only whitespace content
$self = bless { opt => { normalisespace => 2 }, _var_values => {} }, 'XML::Simple';
$attr = { key => '   ' };
$result = eval { XML::Simple::collapse($self, $attr) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result->{key}, '', 'Handle elements with only whitespace content'); }

# Test case 13: Handle elements with attributes that are not scalar values
$self = bless { opt => {}, _var_values => {} }, 'XML::Simple';
$attr = { key => ['value1', 'value2'] };
$result = eval { XML::Simple::collapse($self, $attr) };
if ($@) { fail('Function crashed: ' . $@); } else { is_deeply($result->{key}, ['value1', 'value2'], 'Handle elements with attributes that are not scalar values'); }

# Test case 14: Handle elements with non-unique key attributes
$self = bless { opt => { keyattr => 1 }, _var_values => {} }, 'XML::Simple';
$attr = { key => ['value1', 'value2'] };
$result = eval { XML::Simple::collapse($self, $attr) };
if ($@) { fail('Function crashed: ' . $@); } else { is_deeply($result->{key}, { key => 'value' }, 'Handle elements with non-unique key attributes'); }

done_testing();