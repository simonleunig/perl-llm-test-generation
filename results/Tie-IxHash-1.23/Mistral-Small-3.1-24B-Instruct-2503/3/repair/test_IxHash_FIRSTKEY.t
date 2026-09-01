use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw(mock unmock);
use File::Temp qw(tempfile tempdir);
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::FIRSTKEY"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'FIRSTKEY is defined'); }

# Mocking the NEXTKEY function since it's a dependency
mock 'Tie::IxHash::NEXTKEY' => sub {
    my $self = shift;
    return $self->[0][$self->[3]++];
};

# Test case: Hash is empty
my $empty_hash = bless [], 'Tie::IxHash';
my $result = eval { Tie::IxHash::FIRSTKEY($empty_hash) };
if ($@) { fail('FIRSTKEY crashed with empty hash: ' . $@); } else { is($result, undef, 'FIRSTKEY returns undef for empty hash'); }

# Test case: Hash has one key
my $single_key_hash = bless [['key1', 'value1']], 'Tie::IxHash';
$result = eval { Tie::IxHash::FIRSTKEY($single_key_hash) };
if ($@) { fail('FIRSTKEY crashed with single key hash: ' . $@); } else { is($result, 'key1', 'FIRSTKEY returns the first key for single key hash'); }

# Test case: Hash has multiple keys
my $multi_key_hash = bless [['key1', 'value1'], ['key2', 'value2'], ['key3', 'value3']], 'Tie::IxHash';
$result = eval { Tie::IxHash::FIRSTKEY($multi_key_hash) };
if ($@) { fail('FIRSTKEY crashed with multiple key hash: ' . $@); } else { is($result, 'key1', 'FIRSTKEY returns the first key for multiple key hash'); }

# Test case: Hash is not properly initialized
my $uninitialized_hash = bless [], 'Tie::IxHash';
$result = eval { Tie::IxHash::FIRSTKEY($uninitialized_hash) };
if ($@) { fail('FIRSTKEY crashed with uninitialized hash: ' . $@); } else { is($result, undef, 'FIRSTKEY returns undef for uninitialized hash'); }

# Clean up mocks
unmock 'Tie::IxHash::NEXTKEY';

done_testing();