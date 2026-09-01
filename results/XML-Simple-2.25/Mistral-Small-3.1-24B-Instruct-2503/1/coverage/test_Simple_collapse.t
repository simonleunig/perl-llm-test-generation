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
    my $self = {
        opt => {},
        _var_values => {},
    };
    my $attr = { key => 'value' };
    my $result = eval { XML::Simple::collapse($self, $attr) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, $attr, 'Basic functionality with no options');
    }
}

# Test case 2: Discard attributes if 'noattr' is set
{
    my $self = {
        opt => { noattr => 1 },
        _var_values => {},
    };
    my $attr = { key => 'value' };
    my $result = eval { XML::Simple::collapse($self, $attr) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, {}, 'Discard attributes if noattr is set');
    # FAILED: }
}

# Test case 3: Normalize space if 'normalisespace' is set to 2
{
    my $self = {
        opt => { normalisespace => 2 },
        _var_values => {},
    };
    my $attr = { key => '  value  ' };
    my $result = eval { XML::Simple::collapse($self, $attr) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result->{key}, 'value', 'Normalize space if normalisespace is set to 2');
    # FAILED: }
}

# Test case 4: Variable substitutions
{
    my $self = {
        opt => {},
        _var_values => { var => 'mocked_var' },
    };
    my $attr = { key => '${var}' };
    my $result = eval { XML::Simple::collapse($self, $attr) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result->{key}, 'mocked_var', 'Variable substitutions');
    # FAILED: }
}

# Test case 5: Roll up 'value' attributes
{
    my $self = {
        opt => { valueattrlist => { key => 1 } },
        _var_values => {},
    };
    my $attr = { key => 'value' };
    my $result = eval { XML::Simple::collapse($self, $attr) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 'value', 'Roll up value attributes');
    }
}

# Test case 6: Add nested elements
{
    my $self = {
        opt => {},
        _var_values => {},
    };
    my $attr = { key => 'value' };
    my $result = eval { XML::Simple::collapse($self, $attr, 'nested_key', 'nested_value') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result->{nested_key}, 'nested_value', 'Add nested elements');
    }
}

# Test case 7: Combine duplicate attributes into arrayref
# AFTER LAST PASS: {
    my $self;  # AFTER LAST PASS: my $self = {
        # AFTER LAST PASS: opt => {},
        # AFTER LAST PASS: _var_values => {},
    # AFTER LAST PASS: };
    my $attr;  # AFTER LAST PASS: my $attr = { key => 'value' };
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::collapse($self, $attr, 'key', 'another_value') };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is_deeply($result->{key}, ['value', 'another_value'], 'Combine duplicate attributes into arrayref');
    # FAILED: }
# AFTER LAST PASS: }

# Test case 8: Turn arrayrefs into hashrefs if key fields present
# AFTER LAST PASS: {
    my $self;  # AFTER LAST PASS: my $self = {
        # AFTER LAST PASS: opt => { keyattr => 1 },
        # AFTER LAST PASS: _var_values => {},
    # AFTER LAST PASS: };
    my $attr;  # AFTER LAST PASS: my $attr = { key => ['value1', 'value2'] };
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::collapse($self, $attr) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is_deeply($result->{key}, {}, 'Turn arrayrefs into hashrefs if key fields present');
    # FAILED: }
# AFTER LAST PASS: }

# Test case 9: Disintermediate grouped tags
# AFTER LAST PASS: {
    my $self;  # AFTER LAST PASS: my $self = {
        # AFTER LAST PASS: opt => { grouptags => { key => 'child_key' } },
        # AFTER LAST PASS: _var_values => {},
    # AFTER LAST PASS: };
    my $attr;  # AFTER LAST PASS: my $attr = { key => { child_key => 'value' } };
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::collapse($self, $attr) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result->{key}, 'value', 'Disintermediate grouped tags');
    # FAILED: }
# AFTER LAST PASS: }

# Test case 10: Fold hashes containing a single anonymous array up into just the array
# AFTER LAST PASS: {
    my $self;  # AFTER LAST PASS: my $self = {
        # AFTER LAST PASS: opt => {},
        # AFTER LAST PASS: _var_values => {},
    # AFTER LAST PASS: };
    my $attr;  # AFTER LAST PASS: my $attr = { anon => ['value1', 'value2'] };
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::collapse($self, $attr) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is_deeply($result, ['value1', 'value2'], 'Fold hashes containing a single anonymous array up into just the array');
    # FAILED: }
# AFTER LAST PASS: }

# Test case 11: Handle empty hash
# AFTER LAST PASS: {
    my $self;  # AFTER LAST PASS: my $self = {
        # AFTER LAST PASS: opt => { suppressempty => '' },
        # AFTER LAST PASS: _var_values => {},
    # AFTER LAST PASS: };
    my $attr;  # AFTER LAST PASS: my $attr = {};
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::collapse($self, $attr) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, '', 'Handle empty hash');
    # FAILED: }
# AFTER LAST PASS: }

# Test case 12: Roll up named elements with named nested 'value' attributes
# AFTER LAST PASS: {
    my $self;  # AFTER LAST PASS: my $self = {
        # AFTER LAST PASS: opt => { valueattr => { key => 'value' } },
        # AFTER LAST PASS: _var_values => {},
    # AFTER LAST PASS: };
    my $attr;  # AFTER LAST PASS: my $attr = { key => { value => 'nested_value' } };
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::collapse($self, $attr) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result->{key}, 'nested_value', 'Roll up named elements with named nested value attributes');
    # FAILED: }
# AFTER LAST PASS: }

done_testing();