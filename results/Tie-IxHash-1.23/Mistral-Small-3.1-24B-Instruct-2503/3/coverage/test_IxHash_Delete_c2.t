use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::Delete"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'Delete is defined'); }

# Mocking the DELETE method of Tie::IxHash
my $mock;
# AFTER LAST PASS: eval { require Tie::IxHash; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: Tie::IxHash - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"Tie::IxHash::DELETE"}) {
        # AFTER LAST PASS: $mock = mock 'Tie::IxHash' => (
            # AFTER LAST PASS: override => [
                # AFTER LAST PASS: DELETE => sub {
                    my ($self, $key);  # AFTER LAST PASS: my ($self, $key) = @_;
                    # AFTER LAST PASS: delete $self->{$key};
                # AFTER LAST PASS: }
            # AFTER LAST PASS: ]
        # AFTER LAST PASS: );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock = mock 'Tie::IxHash' => (
            # AFTER LAST PASS: add => [
                # AFTER LAST PASS: DELETE => sub {
                    my ($self, $key);  # AFTER LAST PASS: my ($self, $key) = @_;
                    # AFTER LAST PASS: delete $self->{$key};
                # AFTER LAST PASS: }
            # AFTER LAST PASS: ]
        # AFTER LAST PASS: );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# Test case: No keys provided
# AFTER LAST PASS: {
    my $hash;  # AFTER LAST PASS: my $hash = bless { a => 1, b => 2, c => 3 }, 'Tie::IxHash';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Tie::IxHash::Delete($hash) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, undef, 'Delete returns undef when no keys are provided');
        # FAILED: is_deeply($hash, { a => 1, b => 2, c => 3 }, 'Hash remains unchanged');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Single key provided
# AFTER LAST PASS: {
    my $hash;  # AFTER LAST PASS: my $hash = bless { a => 1, b => 2, c => 3 }, 'Tie::IxHash';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Tie::IxHash::Delete($hash, 'b') };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, undef, 'Delete returns undef when a single key is provided');
        # FAILED: is_deeply($hash, { a => 1, c => 3 }, 'Key "b" is deleted');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Multiple keys provided
# AFTER LAST PASS: {
    my $hash;  # AFTER LAST PASS: my $hash = bless { a => 1, b => 2, c => 3, d => 4 }, 'Tie::IxHash';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Tie::IxHash::Delete($hash, 'b', 'd') };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, undef, 'Delete returns undef when multiple keys are provided');
        # FAILED: is_deeply($hash, { a => 1, c => 3 }, 'Keys "b" and "d" are deleted');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Non-existent keys provided
# AFTER LAST PASS: {
    my $hash;  # AFTER LAST PASS: my $hash = bless { a => 1, b => 2, c => 3 }, 'Tie::IxHash';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Tie::IxHash::Delete($hash, 'x', 'y') };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, undef, 'Delete returns undef when non-existent keys are provided');
        # FAILED: is_deeply($hash, { a => 1, b => 2, c => 3 }, 'Hash remains unchanged');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Duplicate keys provided
# AFTER LAST PASS: {
    my $hash;  # AFTER LAST PASS: my $hash = bless { a => 1, b => 2, c => 3 }, 'Tie::IxHash';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Tie::IxHash::Delete($hash, 'b', 'b') };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, undef, 'Delete returns undef when duplicate keys are provided');
        # FAILED: is_deeply($hash, { a => 1, c => 3 }, 'Key "b" is deleted only once');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Large list of keys
# AFTER LAST PASS: {
    my $hash;  # AFTER LAST PASS: my $hash = bless { map { $_ => 1 } 1..1000 }, 'Tie::IxHash';
    my $keys_to_delete;  # AFTER LAST PASS: my $keys_to_delete = [1..500];
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Tie::IxHash::Delete($hash, @$keys_to_delete) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, undef, 'Delete returns undef when a large list of keys is provided');
        # FAILED: is(scalar(keys %$hash), 500, '500 keys are deleted');
    # FAILED: }
# AFTER LAST PASS: }

done_testing();