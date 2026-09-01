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
                set_var => sub { return },
                array_to_hash => sub { return {} },
            ]
        );
    } else {
        $mock = mock 'XML::Simple' => (
            add => [
                new_hashref => sub { return {} },
                normalise_space => sub { return shift },
                get_var => sub { return 'mocked_var' },
                set_var => sub { return },
                array_to_hash => sub { return {} },
            ]
        );
    }
}

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::collapse"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'collapse is defined'); }

# Test case 1: Basic functionality with no options
{
    my $self = bless { opt => {} }, 'XML::Simple';
    my $attr = { key => 'value' };
    my $result = eval { XML::Simple::collapse($self, $attr) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, $attr, 'Basic functionality with no options');
    }
}

# Test case 2: Discard attributes if 'noattr' is set
{
    my $self = bless { opt => { noattr => 1 } }, 'XML::Simple';
    my $attr = { key => 'value' };
    my $result = eval { XML::Simple::collapse($self, $attr) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, {}, 'Discard attributes if noattr is set');
    }
}

# Test case 3: Normalize space in attributes
{
    my $self = bless { opt => { normalisespace => 2 } }, 'XML::Simple';
    my $attr = { key => '  value  ' };
    my $result = eval { XML::Simple::collapse($self, $attr) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result->{key}, 'value', 'Normalize space in attributes');
    }
}

# Test case 4: Variable substitutions in attributes
{
    my $self = bless { opt => {}, _var_values => 1 }, 'XML::Simple';
    my $attr = { key => '${var}' };
    my $result = eval { XML::Simple::collapse($self, $attr) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result->{key}, 'mocked_var', 'Variable substitutions in attributes');
    }
}

# Test case 5: Roll up 'value' attributes
{
    my $self = bless { opt => { valueattrlist => { key => 1 } } }, 'XML::Simple';
    my $attr = { key => 'value' };
    my $result = eval { XML::Simple::collapse($self, $attr) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 'value', 'Roll up value attributes');
    }
}

# Test case 6: Add nested elements
{
    my $self = bless { opt => {} }, 'XML::Simple';
    my $attr = { key => 'value' };
    my $result = eval { XML::Simple::collapse($self, $attr, 'nested_key', 'nested_value') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result->{nested_key}, 'nested_value', 'Add nested elements');
    }
}

# Test case 7: Combine duplicate attributes into arrayref
{
    my $self = bless { opt => {} }, 'XML::Simple';
    my $attr = { key => 'value' };
    my $result = eval { XML::Simple::collapse($self, $attr, 'key', 'another_value') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is_deeply($result->{key}, ['value', 'another_value'], 'Combine duplicate attributes into arrayref');
    }
}

# Test case 8: Turn arrayrefs into hashrefs if key fields present
{
    my $self = bless { opt => { keyattr => 1 } }, 'XML::Simple';
    my $attr = { key => ['value1', 'value2'] };
    my $result = eval { XML::Simple::collapse($self, $attr) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is_deeply($result->{key}, {}, 'Turn arrayrefs into hashrefs if key fields present');
    }
}

# Test case 9: Disintermediate grouped tags
{
    my $self = bless { opt => { grouptags => { key => 'child_key' } } }, 'XML::Simple';
    my $attr = { key => { child_key => 'value' } };
    my $result = eval { XML::Simple::collapse($self, $attr) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result->{key}, 'value', 'Disintermediate grouped tags');
    }
}

# Test case 10: Fold hashes containing a single anonymous array up into just the array
{
    my $self = bless { opt => {} }, 'XML::Simple';
    my $attr = { anon => ['value1', 'value2'] };
    my $result = eval { XML::Simple::collapse($self, $attr) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is_deeply($result, ['value1', 'value2'], 'Fold hashes containing a single anonymous array up into just the array');
    }
}

# Test case 11: Handle empty hash
{
    my $self = bless { opt => { suppressempty => '' } }, 'XML::Simple';
    my $attr = {};
    my $result = eval { XML::Simple::collapse($self, $attr) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, '', 'Handle empty hash');
    }
}

# Test case 12: Roll up named elements with named nested 'value' attributes
{
    my $self = bless { opt => { valueattr => { key => 'value' } } }, 'XML::Simple';
    my $attr = { key => { value => 'nested_value' } };
    my $result = eval { XML::Simple::collapse($self, $attr) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result->{key}, 'nested_value', 'Roll up named elements with named nested value attributes');
    }
}

done_testing();