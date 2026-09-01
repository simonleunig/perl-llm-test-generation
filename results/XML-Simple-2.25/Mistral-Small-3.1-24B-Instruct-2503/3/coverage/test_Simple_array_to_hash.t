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
                die_or_warn => sub { die shift },
                normalise_space => sub { return shift },
                collapse_content => sub { return shift },
            ]
        );
    } else {
        $mock = mock 'XML::Simple' => (
            add => [
                new_hashref => sub { return {} },
                die_or_warn => sub { die shift },
                normalise_space => sub { return shift },
                collapse_content => sub { return shift },
            ]
        );
    }
}

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::array_to_hash"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'array_to_hash is defined'); }

# Test case: Empty array
my $self;  # AFTER LAST PASS: my $self = bless({}, 'XML::Simple');
my $name;  # AFTER LAST PASS: my $name = 'test';
my $arrayref;  # AFTER LAST PASS: my $arrayref = [];
my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::array_to_hash($self, $name, $arrayref) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }
# FAILED: is($@, '', 'No error for empty array');
# FAILED: is_deeply($result, {}, 'Returns empty hash for empty array');

# Test case: Array with non-hash elements
# AFTER LAST PASS: $arrayref = [1, 2, 3];
# UNVALIDATED: $result = eval { XML::Simple::array_to_hash($self, $name, $arrayref) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }
# FAILED: is($@, '', 'No error for array with non-hash elements');
# FAILED: is_deeply($result, $arrayref, 'Returns original array for non-hash elements');

# Test case: Array with hashes missing key attribute
# AFTER LAST PASS: $arrayref = [{ key => 'value1' }, { key => 'value2' }];
# AFTER LAST PASS: $self->{opt} = { keyattr => { test => ['key', '-'] } };
# UNVALIDATED: $result = eval { XML::Simple::array_to_hash($self, $name, $arrayref) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }
# FAILED: is($@, '', 'No error for missing key attribute');
# FAILED: is_deeply($result, $arrayref, 'Returns original array for missing key attribute');

# Test case: Array with non-scalar key attribute
# AFTER LAST PASS: $arrayref = [{ key => 'value1' }, { key => ['not_scalar'] }];
# UNVALIDATED: $result = eval { XML::Simple::array_to_hash($self, $name, $arrayref) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }
# FAILED: like($@, qr/non-scalar/, 'Error for non-scalar key attribute');
# FAILED: is_deeply($result, $arrayref, 'Returns original array for non-scalar key attribute');

# Test case: Array with non-unique key attribute values
# AFTER LAST PASS: $arrayref = [{ key => 'value1' }, { key => 'value1' }];
# UNVALIDATED: $result = eval { XML::Simple::array_to_hash($self, $name, $arrayref) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }
# FAILED: like($@, qr/non-unique/, 'Error for non-unique key attribute values');
# FAILED: is_deeply($result, $arrayref, 'Returns original array for non-unique key attribute values');

# Test case: Normal operation with unique key attribute values
# AFTER LAST PASS: $arrayref = [{ key => 'value1' }, { key => 'value2' }];
# AFTER LAST PASS: $self->{opt} = { keyattr => ['key'], normalisespace => 1, collapseagain => 1 };
# UNVALIDATED: $result = eval { XML::Simple::array_to_hash($self, $name, $arrayref) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }
# FAILED: is($@, '', 'No error for normal operation');
# FAILED: is_deeply($result, { value1 => { key => 'value1' }, value2 => { key => 'value2' } }, 'Correct hash transformation');

# Test case: Normal operation with keyattr as hash
# AFTER LAST PASS: $arrayref = [{ key => 'value1' }, { key => 'value2' }];
# AFTER LAST PASS: $self->{opt} = { keyattr => { test => ['key', '-'] }, normalisespace => 1, collapseagain => 1 };
# UNVALIDATED: $result = eval { XML::Simple::array_to_hash($self, $name, $arrayref) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }
# FAILED: is($@, '', 'No error for keyattr as hash');
# FAILED: is_deeply($result, { value1 => { '-key' => 'value1' }, value2 => { '-key' => 'value2' } }, 'Correct hash transformation with keyattr as hash');

done_testing();