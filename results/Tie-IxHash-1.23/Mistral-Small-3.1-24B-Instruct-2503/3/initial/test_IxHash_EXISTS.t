use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }  # Use actual module name from package declaration

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::EXISTS"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'EXISTS is defined'); }

# Mocking the Tie::IxHash object
my $mock_hash = mock('Tie::IxHash', override => [
    'TIEHASH' => sub {
        my $class = shift;
        my $self = bless [{}], $class;
        return $self;
    },
]);

# Test case: Key exists in the hash
{
    my $hash = $mock_hash->TIEHASH();
    $hash->[0]{'key1'} = 1;
    my $result = eval { Tie::IxHash::EXISTS($hash, 'key1') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 1, 'Key exists in the hash');
    }
}

# Test case: Key does not exist in the hash
{
    my $hash = $mock_hash->TIEHASH();
    my $result = eval { Tie::IxHash::EXISTS($hash, 'key2') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, '', 'Key does not exist in the hash');
    }
}

# Test case: Key is an empty string
{
    my $hash = $mock_hash->TIEHASH();
    my $result = eval { Tie::IxHash::EXISTS($hash, '') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, '', 'Key is an empty string');
    }
}

# Test case: Key is undefined
{
    my $hash = $mock_hash->TIEHASH();
    my $result = eval { Tie::IxHash::EXISTS($hash, undef) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, '', 'Key is undefined');
    }
}

# Test case: Hash object is not properly initialized
{
    my $result = eval { Tie::IxHash::EXISTS(undef, 'key1') };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, '', 'Hash object is not properly initialized');
    }
}

done_testing();
