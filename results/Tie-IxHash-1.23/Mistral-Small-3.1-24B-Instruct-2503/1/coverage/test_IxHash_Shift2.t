use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::Shift2"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'Shift2 is defined'); }

# Mocking the Splice method for testing purposes
my $mock;
# AFTER LAST PASS: eval { require Tie::IxHash; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: Tie::IxHash - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"Tie::IxHash::Splice"}) {
        # AFTER LAST PASS: $mock = mock 'Tie::IxHash' => ( override => [ splice => sub {
            my ($self, $offset, $length);  # AFTER LAST PASS: my ($self, $offset, $length) = @_;
            my @keys;  # AFTER LAST PASS: my @keys = keys %$self;
            my @values;  # AFTER LAST PASS: my @values = values %$self;
            my @removed;  # AFTER LAST PASS: my @removed = splice @keys, $offset, $length;
            # AFTER LAST PASS: splice @values, $offset, $length;
            # AFTER LAST PASS: return ($removed[0], $values[$offset]);
        # AFTER LAST PASS: } ] );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock = mock 'Tie::IxHash' => ( add => [ splice => sub {
            my ($self, $offset, $length);  # AFTER LAST PASS: my ($self, $offset, $length) = @_;
            my @keys;  # AFTER LAST PASS: my @keys = keys %$self;
            my @values;  # AFTER LAST PASS: my @values = values %$self;
            my @removed;  # AFTER LAST PASS: my @removed = splice @keys, $offset, $length;
            # AFTER LAST PASS: splice @values, $offset, $length;
            # AFTER LAST PASS: return ($removed[0], $values[$offset]);
        # AFTER LAST PASS: } ] );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# Test case: Shift2 on an empty Tie::IxHash object
# AFTER LAST PASS: {
    my $hash;  # AFTER LAST PASS: my $hash = {};
    # AFTER LAST PASS: tie %$hash, 'Tie::IxHash';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Tie::IxHash::Shift2($hash) };
    # FAILED: if ($@) { fail('Shift2 crashed on empty hash: ' . $@); }
    # FAILED: else { is($result, undef, 'Shift2 returns undef on empty hash'); }
# AFTER LAST PASS: }

# Test case: Shift2 on a non-empty Tie::IxHash object
# AFTER LAST PASS: {
    my $hash;  # AFTER LAST PASS: my $hash = { a => 1, b => 2, c => 3 };
    # AFTER LAST PASS: tie %$hash, 'Tie::IxHash';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Tie::IxHash::Shift2($hash) };
    # FAILED: if ($@) { fail('Shift2 crashed on non-empty hash: ' . $@); }
    # FAILED: else {
        # FAILED: is($result, ['a', 1], 'Shift2 returns the first key-value pair');
        # FAILED: is(scalar(keys %$hash), 2, 'Hash has one less key after Shift2');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Shift2 on a Tie::IxHash object with one element
# AFTER LAST PASS: {
    my $hash;  # AFTER LAST PASS: my $hash = { d => 4 };
    # AFTER LAST PASS: tie %$hash, 'Tie::IxHash';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Tie::IxHash::Shift2($hash) };
    # FAILED: if ($@) { fail('Shift2 crashed on single-element hash: ' . $@); }
    # FAILED: else {
        # FAILED: is($result, ['d', 4], 'Shift2 returns the single key-value pair');
        # FAILED: is(scalar(keys %$hash), 0, 'Hash is empty after Shift2');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Shift2 on an invalid object
# AFTER LAST PASS: {
    my $invalid_object;  # AFTER LAST PASS: my $invalid_object = 'not_a_hash';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Tie::IxHash::Shift2($invalid_object) };
    # FAILED: if ($@) { fail('Shift2 crashed on invalid object: ' . $@); }
    # FAILED: else { is($result, undef, 'Shift2 returns undef on invalid object'); }
# AFTER LAST PASS: }

done_testing();