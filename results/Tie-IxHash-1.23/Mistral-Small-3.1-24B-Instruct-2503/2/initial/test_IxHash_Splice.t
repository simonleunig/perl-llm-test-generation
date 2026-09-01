use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Tie::IxHash; }  # Use actual module name from package declaration

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Tie::IxHash::Splice"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'Splice is defined'); }

# Mock the _lrange method
mock 'Tie::IxHash::_lrange' => sub {
    my ($self, $start, $len) = @_;
    return ($start, $start + $len - 1, $len);
};

# Helper function to create a Tie::IxHash object
sub create_ixhash {
    my %hash = @_;
    tie my %tied_hash, 'Tie::IxHash';
    %tied_hash = %hash;
    return \%tied_hash;
}

# Test case 1: Basic splice operation
{
    my $ixhash = create_ixhash(a => 1, b => 2, c => 3);
    my $result = eval { Tie::IxHash::Splice($ixhash, 1, 1) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 'b', 'Splice removes correct element');
        is_deeply($ixhash, { a => 1, c => 3 }, 'Hash is modified correctly');
    }
}

# Test case 2: Splice with insertion
{
    my $ixhash = create_ixhash(a => 1, b => 2, c => 3);
    my $result = eval { Tie::IxHash::Splice($ixhash, 1, 1, d => 4) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 'b', 'Splice removes correct element');
        is_deeply($ixhash, { a => 1, d => 4, c => 3 }, 'Hash is modified correctly with insertion');
    }
}

# Test case 3: Splice with negative offset
{
    my $ixhash = create_ixhash(a => 1, b => 2, c => 3);
    my $result = eval { Tie::IxHash::Splice($ixhash, -2, 1) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 'b', 'Splice removes correct element with negative offset');
        is_deeply($ixhash, { a => 1, c => 3 }, 'Hash is modified correctly with negative offset');
    }
}

# Test case 4: Splice with length 0
{
    my $ixhash = create_ixhash(a => 1, b => 2, c => 3);
    my $result = eval { Tie::IxHash::Splice($ixhash, 1, 0) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, '', 'Splice removes no elements with length 0');
        is_deeply($ixhash, { a => 1, b => 2, c => 3 }, 'Hash remains unchanged with length 0');
    }
}

# Test case 5: Splice with insertion of existing key
{
    my $ixhash = create_ixhash(a => 1, b => 2, c => 3);
    my $result = eval { Tie::IxHash::Splice($ixhash, 1, 1, b => 4) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 'b', 'Splice removes correct element');
        is_deeply($ixhash, { a => 1, b => 4, c => 3 }, 'Hash is modified correctly with insertion of existing key');
    }
}

# Test case 6: Splice with out-of-bounds index
{
    my $ixhash = create_ixhash(a => 1, b => 2, c => 3);
    my $result = eval { Tie::IxHash::Splice($ixhash, 5, 1) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, '', 'Splice removes no elements with out-of-bounds index');
        is_deeply($ixhash, { a => 1, b => 2, c => 3 }, 'Hash remains unchanged with out-of-bounds index');
    }
}

done_testing();
