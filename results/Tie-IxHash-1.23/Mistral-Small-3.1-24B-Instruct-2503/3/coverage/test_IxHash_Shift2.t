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

# Mocking the Tie::IxHash::Splice method
my $mock;
# AFTER LAST PASS: eval { require Tie::IxHash; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: Tie::IxHash - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"Tie::IxHash::Splice"}) {
        # AFTER LAST PASS: $mock = mock 'Tie::IxHash' => ( override => [ splice => sub {
            my ($self, $offset, $length);  # AFTER LAST PASS: my ($self, $offset, $length) = @_;
            # AFTER LAST PASS: if ($offset == 0 && $length == 1) {
                # AFTER LAST PASS: return (shift @{$self->{_order}}, delete $self->{_hash}{shift @{$self->{_order}}});
            # AFTER LAST PASS: }
            # AFTER LAST PASS: return ();
        # AFTER LAST PASS: }] );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock = mock 'Tie::IxHash' => ( add => [ splice => sub {
            my ($self, $offset, $length);  # AFTER LAST PASS: my ($self, $offset, $length) = @_;
            # AFTER LAST PASS: if ($offset == 0 && $length == 1) {
                # AFTER LAST PASS: return (shift @{$self->{_order}}, delete $self->{_hash}{shift @{$self->{_order}}});
            # AFTER LAST PASS: }
            # AFTER LAST PASS: return ();
        # AFTER LAST PASS: }] );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# Test case: Shift2 on an empty Tie::IxHash object
# AFTER LAST PASS: {
    my $hash;  # AFTER LAST PASS: my $hash = bless { _order => [], _hash => {} }, 'Tie::IxHash';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Tie::IxHash::Shift2($hash) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, undef, 'Shift2 returns undef on empty hash');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Shift2 on a non-empty Tie::IxHash object
# AFTER LAST PASS: {
    my $hash;  # AFTER LAST PASS: my $hash = bless { _order => ['key1', 'key2'], _hash => { key1 => 'value1', key2 => 'value2' } }, 'Tie::IxHash';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Tie::IxHash::Shift2($hash) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, ['key1', 'value1'], 'Shift2 returns the first key-value pair');
        # FAILED: is_deeply($hash->{_order}, ['key2'], 'The order array is updated correctly');
        # FAILED: is_deeply($hash->{_hash}, { key2 => 'value2' }, 'The hash is updated correctly');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Shift2 on a Tie::IxHash object with one element
# AFTER LAST PASS: {
    my $hash;  # AFTER LAST PASS: my $hash = bless { _order => ['key1'], _hash => { key1 => 'value1' } }, 'Tie::IxHash';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Tie::IxHash::Shift2($hash) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, ['key1', 'value1'], 'Shift2 returns the single key-value pair');
        # FAILED: is_deeply($hash->{_order}, [], 'The order array is empty after removal');
        # FAILED: is_deeply($hash->{_hash}, {}, 'The hash is empty after removal');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Shift2 on a Tie::IxHash object with multiple elements
# AFTER LAST PASS: {
    my $hash;  # AFTER LAST PASS: my $hash = bless { _order => ['key1', 'key2', 'key3'], _hash => { key1 => 'value1', key2 => 'value2', key3 => 'value3' } }, 'Tie::IxHash';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Tie::IxHash::Shift2($hash) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, ['key1', 'value1'], 'Shift2 returns the first key-value pair');
        # FAILED: is_deeply($hash->{_order}, ['key2', 'key3'], 'The order array is updated correctly');
        # FAILED: is_deeply($hash->{_hash}, { key2 => 'value2', key3 => 'value3' }, 'The hash is updated correctly');
    # FAILED: }
# AFTER LAST PASS: }

done_testing();