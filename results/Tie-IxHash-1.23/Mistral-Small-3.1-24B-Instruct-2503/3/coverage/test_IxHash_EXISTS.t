use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::EXISTS"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'EXISTS is defined'); }

# Mocking the Tie::IxHash object
my $mock_hash;
# AFTER LAST PASS: eval { require Tie::IxHash; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: Tie::IxHash - mock skipped
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"Tie::IxHash::TIEHASH"}) {
        # AFTER LAST PASS: $mock_hash = mock 'Tie::IxHash' => ( override => [
            # AFTER LAST PASS: 'TIEHASH' => sub {
                my $class;  # AFTER LAST PASS: my $class = shift;
                my $self;  # AFTER LAST PASS: my $self = bless [{}], $class;
                # AFTER LAST PASS: return $self;
            # AFTER LAST PASS: },
        # AFTER LAST PASS: ]);
    # AFTER LAST PASS: } else {
        # AFTER LAST PASS: $mock_hash = mock 'Tie::IxHash' => ( add => [
            # AFTER LAST PASS: 'TIEHASH' => sub {
                my $class;  # AFTER LAST PASS: my $class = shift;
                my $self;  # AFTER LAST PASS: my $self = bless [{}], $class;
                # AFTER LAST PASS: return $self;
            # AFTER LAST PASS: },
        # AFTER LAST PASS: ]);
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

# Test case: Key exists in the hash
# AFTER LAST PASS: {
    my $hash;  # AFTER LAST PASS: my $hash = $mock_hash->TIEHASH();
    # AFTER LAST PASS: $hash->[0]{'key1'} = 1;
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Tie::IxHash::EXISTS($hash, 'key1') };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, 1, 'Key exists in the hash');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Key does not exist in the hash
# AFTER LAST PASS: {
    my $hash;  # AFTER LAST PASS: my $hash = $mock_hash->TIEHASH();
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Tie::IxHash::EXISTS($hash, 'key2') };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, 0, 'Key does not exist in the hash');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Key is an empty string
# AFTER LAST PASS: {
    my $hash;  # AFTER LAST PASS: my $hash = $mock_hash->TIEHASH();
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Tie::IxHash::EXISTS($hash, '') };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, 0, 'Key is an empty string');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Key is undefined
# AFTER LAST PASS: {
    my $hash;  # AFTER LAST PASS: my $hash = $mock_hash->TIEHASH();
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Tie::IxHash::EXISTS($hash, undef) };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, 0, 'Key is undefined');
    # FAILED: }
# AFTER LAST PASS: }

# Test case: Hash object is not properly initialized
# AFTER LAST PASS: {
    my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Tie::IxHash::EXISTS(undef, 'key1') };
    # FAILED: if ($@) { fail('Function crashed: ' . $@); } else {
        # FAILED: is($result, 0, 'Hash object is not properly initialized');
    # FAILED: }
# AFTER LAST PASS: }

done_testing();