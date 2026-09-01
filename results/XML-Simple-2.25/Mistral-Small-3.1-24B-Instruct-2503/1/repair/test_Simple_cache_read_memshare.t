use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::cache_read_memshare"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'cache_read_memshare is defined'); }

# Mocking dependencies
my $mock;
eval { require XML::Simple; };
if ($@) {
    # DEPENDENCY MISSING: XML::Simple - mock skipped
} else {
    no strict 'refs';
    if (defined &{"XML::Simple::stat"}) {
        $mock = mock 'XML::Simple' => ( override => [ 'stat' => sub { return (0) x 13; } ] );
    } else {
        $mock = mock 'XML::Simple' => ( add => [ 'stat' => sub { return (0) x 13; } ] );
    }
}

# Test case 1: Cache exists and is up-to-date
{
    mock 'XML::Simple', 'MemShareCache' => { 'test.xml' => [ time() + 1, 'cached_data' ] };
    my $filename = 'test.xml';
    my $result = eval { XML::Simple::cache_read_memshare(undef, $filename) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, 'cached_data', 'Cache exists and is up-to-date');
    }
}

# Test case 2: Cache does not exist
{
    mock 'XML::Simple', 'MemShareCache' => {};
    my $filename = 'nonexistent.xml';
    my $result = eval { XML::Simple::cache_read_memshare(undef, $filename) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, undef, 'Cache does not exist');
    }
}

# Test case 3: Cache is outdated
{
    mock 'XML::Simple', 'MemShareCache' => { 'test.xml' => [ time() - 1, 'cached_data' ] };
    my $filename = 'test.xml';
    my $result = eval { XML::Simple::cache_read_memshare(undef, $filename) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, undef, 'Cache is outdated');
    }
}

# Test case 4: Filename does not exist
{
    my $filename = 'nonexistent.xml';
    my $result = eval { XML::Simple::cache_read_memshare(undef, $filename) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, undef, 'Filename does not exist');
    }
}

done_testing();