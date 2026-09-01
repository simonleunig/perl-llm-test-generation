use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }  # Use actual module name from package declaration

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::STORE"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'STORE is defined'); }

# Helper function to create a tied hash
sub create_tied_ixhash {
    my $hash = {};
    tie %$hash, 'Tie::IxHash';
    return $hash;
}

# Test case: Adding a new key-value pair
{
    my $hash = create_tied_ixhash();
    my $key = 'key1';
    my $value = 'value1';

    my $result = eval { $hash->{$key} = $value };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(defined $result, 'Function returns result');
        is($hash->{$key}, $value, 'Key-value pair added correctly');
        is(scalar(keys %$hash), 1, 'Hash has one key');
    }
}

# Test case: Updating an existing key-value pair
{
    my $hash = create_tied_ixhash();
    my $key = 'key1';
    my $value1 = 'value1';
    my $value2 = 'value2';

    $hash->{$key} = $value1;
    my $result = eval { $hash->{$key} = $value2 };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(defined $result, 'Function returns result');
        is($hash->{$key}, $value2, 'Key-value pair updated correctly');
        is(scalar(keys %$hash), 1, 'Hash still has one key');
    }
}

# Test case: Adding multiple key-value pairs
{
    my $hash = create_tied_ixhash();
    my %data = (
        key1 => 'value1',
        key2 => 'value2',
        key3 => 'value3',
    );

    foreach my $key (keys %data) {
        my $result = eval { $hash->{$key} = $data{$key} };
        if ($@) { fail('Function crashed: ' . $@); } else {
            ok(defined $result, 'Function returns result');
            is($hash->{$key}, $data{$key}, 'Key-value pair added correctly');
        }
    }

    is(scalar(keys %$hash), 3, 'Hash has three keys');
}

# Test case: Adding a key-value pair with an existing key
{
    my $hash = create_tied_ixhash();
    my $key = 'key1';
    my $value1 = 'value1';
    my $value2 = 'value2';

    $hash->{$key} = $value1;
    my $result = eval { $hash->{$key} = $value2 };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(defined $result, 'Function returns result');
        is($hash->{$key}, $value2, 'Key-value pair updated correctly');
        is(scalar(keys %$hash), 1, 'Hash still has one key');
    }
}

# Test case: Adding a key-value pair with an undefined value
{
    my $hash = create_tied_ixhash();
    my $key = 'key1';
    my $value = undef;

    my $result = eval { $hash->{$key} = $value };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(defined $result, 'Function returns result');
        is($hash->{$key}, $value, 'Key-value pair added with undefined value');
        is(scalar(keys %$hash), 1, 'Hash has one key');
    }
}

done_testing();
