use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::new"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'new is defined'); }

# Mocking TIEHASH function
my $mock;
eval { require Tie::IxHash; };
if ($@) {
    # DEPENDENCY MISSING: Tie::IxHash - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Tie::IxHash::TIEHASH"}) {
        $mock = mock 'Tie::IxHash' => ( override => [ 'TIEHASH' => sub {
            my $class = shift;
            my %args = @_;
            return bless { %args }, $class;
        } ] );
    } else {
        $mock = mock 'Tie::IxHash' => ( add => [ 'TIEHASH' => sub {
            my $class = shift;
            my %args = @_;
            return bless { %args }, $class;
        } ] );
    }
}

# Test case: Normal operation with key-value pairs
my $result = eval { Tie::IxHash->new(key1 => 'value1', key2 => 'value2') };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'Function returns result');
    isa_ok($result, 'Tie::IxHash', 'Result is a Tie::IxHash object');
    is($result->{key1}, 'value1', 'Key-value pair key1 => value1 is stored');
    is($result->{key2}, 'value2', 'Key-value pair key2 => value2 is stored');
}

# Test case: No key-value pairs provided
$result = eval { Tie::IxHash->new() };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'Function returns result');
    isa_ok($result, 'Tie::IxHash', 'Result is a Tie::IxHash object');
    is(scalar keys %$result, 0, 'Hash is empty when no key-value pairs are provided');
}

# Test case: Duplicate keys provided
$result = eval { Tie::IxHash->new(key1 => 'value1', key1 => 'value2') };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'Function returns result');
    isa_ok($result, 'Tie::IxHash', 'Result is a Tie::IxHash object');
    is($result->{key1}, 'value2', 'Last value for duplicate key is stored');
}

# Test case: Invalid inputs (non-key-value pairs)
$result = eval { Tie::IxHash->new('invalid', 'input') };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'Function returns result');
    isa_ok($result, 'Tie::IxHash', 'Result is a Tie::IxHash object');
    is(scalar keys %$result, 0, 'Non-key-value pairs are ignored');
}

done_testing();