use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }  # Use actual module name from package declaration

# Mocking dependencies
mock 'XML::Simple', 'MemShareCache' => {};
mock 'XML::Simple', 'stat' => sub { return (0, 0, 0, 0, 0, 0, 0, 0, 0, 1234567890); };

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::cache_read_memshare"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'cache_read_memshare is defined'); }

# Test case 1: Cache exists and is up-to-date
{
    my $filename = 'test.xml';
    my $cached_data = { key => 'value' };
    $XML::Simple::MemShareCache{$filename} = [1234567891, $cached_data];

    my $result = eval { XML::Simple::cache_read_memshare(undef, $filename) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, $cached_data, 'Cache exists and is up-to-date');
    }
}

# Test case 2: Cache does not exist
{
    my $filename = 'test2.xml';
    $XML::Simple::MemShareCache{$filename} = undef;

    my $result = eval { XML::Simple::cache_read_memshare(undef, $filename) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, undef, 'Cache does not exist');
    }
}

# Test case 3: Cache is outdated
{
    my $filename = 'test3.xml';
    my $cached_data = { key => 'value' };
    $XML::Simple::MemShareCache{$filename} = [1234567889, $cached_data];

    my $result = eval { XML::Simple::cache_read_memshare(undef, $filename) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, undef, 'Cache is outdated');
    }
}

# Test case 4: File does not exist (mocked stat to return undef)
{
    mock 'XML::Simple', 'stat' => sub { return undef; };
    my $filename = 'nonexistent.xml';

    my $result = eval { XML::Simple::cache_read_memshare(undef, $filename) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        is($result, undef, 'File does not exist');
    }
}

done_testing();
