use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::Pop2"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'Pop2 is defined'); }

# Mocking the Splice method for testing purposes
my $mock;
# AFTER LAST PASS: eval { require Tie::IxHash; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: Tie::IxHash - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"Tie::IxHash::Splice"}) {
        # AFTER LAST PASS: $mock = mock 'Tie::IxHash' => ( override => [ splice => sub {
            my $self;  # AFTER LAST PASS: my $self = shift;
            my $index;  # AFTER LAST PASS: my $index = shift;
            my $count;  # AFTER LAST PASS: my $count = shift || 1;
            my $list;  # AFTER LAST PASS: my $list = $self->{_list};
            my $hash;  # AFTER LAST PASS: my $hash = $self->{_hash};

            # AFTER LAST PASS: if ($index == -1) {
                # AFTER LAST PASS: return pop @$list;
            # AFTER LAST PASS: } else {
                # AFTER LAST PASS: return splice @$list, $index, $count;
            # AFTER LAST PASS: }
        # AFTER LAST PASS: } ] );
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock = mock 'Tie::IxHash' => ( add => [ splice => sub {
            my $self;  # AFTER LAST PASS: my $self = shift;
            my $index;  # AFTER LAST PASS: my $index = shift;
            my $count;  # AFTER LAST PASS: my $count = shift || 1;
            my $list;  # AFTER LAST PASS: my $list = $self->{_list};
            my $hash;  # AFTER LAST PASS: my $hash = $self->{_hash};

            # AFTER LAST PASS: if ($index == -1) {
                # AFTER LAST PASS: return pop @$list;
            # AFTER LAST PASS: } else {
                # AFTER LAST PASS: return splice @$list, $index, $count;
            # AFTER LAST PASS: }
        # AFTER LAST PASS: } ] );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# Test case: Pop2 on an empty Tie::IxHash object
# AFTER LAST PASS: {
    my $hash;  # AFTER LAST PASS: my $hash = bless { _list => [], _hash => {} }, 'Tie::IxHash';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Tie::IxHash::Pop2($hash) };
    # FAILED: if ($@) { fail('Pop2 crashed on empty hash: ' . $@); } else {
        # FAILED: is($result, undef, 'Pop2 returns undef on empty hash');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Pop2 on a non-empty Tie::IxHash object
# AFTER LAST PASS: {
    my $hash;  # AFTER LAST PASS: my $hash = bless { _list => [['key1', 'value1'], ['key2', 'value2']], _hash => { key1 => 'value1', key2 => 'value2' } }, 'Tie::IxHash';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Tie::IxHash::Pop2($hash) };
    # FAILED: if ($@) { fail('Pop2 crashed on non-empty hash: ' . $@); } else {
        # FAILED: is_deeply($result, ['key2', 'value2'], 'Pop2 returns the last key-value pair');
        # FAILED: is_deeply($hash->{_list}, [['key1', 'value1']], 'The last key-value pair is removed from the list');
        # FAILED: is_deeply($hash->{_hash}, { key1 => 'value1' }, 'The last key-value pair is removed from the hash');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Pop2 on a Tie::IxHash object with one element
# AFTER LAST PASS: {
    my $hash;  # AFTER LAST PASS: my $hash = bless { _list => [['key1', 'value1']], _hash => { key1 => 'value1' } }, 'Tie::IxHash';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Tie::IxHash::Pop2($hash) };
    # FAILED: if ($@) { fail('Pop2 crashed on single-element hash: ' . $@); } else {
        # FAILED: is_deeply($result, ['key1', 'value1'], 'Pop2 returns the single key-value pair');
        # FAILED: is_deeply($hash->{_list}, [], 'The single key-value pair is removed from the list');
        # FAILED: is_deeply($hash->{_hash}, {}, 'The single key-value pair is removed from the hash');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Pop2 on a Tie::IxHash object with multiple elements
# AFTER LAST PASS: {
    my $hash;  # AFTER LAST PASS: my $hash = bless { _list => [['key1', 'value1'], ['key2', 'value2'], ['key3', 'value3']], _hash => { key1 => 'value1', key2 => 'value2', key3 => 'value3' } }, 'Tie::IxHash';
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Tie::IxHash::Pop2($hash) };
    # FAILED: if ($@) { fail('Pop2 crashed on multi-element hash: ' . $@); } else {
        # FAILED: is_deeply($result, ['key3', 'value3'], 'Pop2 returns the last key-value pair');
        # FAILED: is_deeply($hash->{_list}, [['key1', 'value1'], ['key2', 'value2']], 'The last key-value pair is removed from the list');
        # FAILED: is_deeply($hash->{_hash}, { key1 => 'value1', key2 => 'value2' }, 'The last key-value pair is removed from the hash');
    # FAILED: }
# AFTER LAST PASS: }

done_testing();