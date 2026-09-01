use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }  # Use actual module name from package declaration

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::cache_write_memshare"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'cache_write_memshare is defined'); }

# Mock the global hash %MemShareCache
my %MemShareCache;
mock 'XML::Simple::MemShareCache', \%MemShareCache;

# Test case 1: Normal operation with valid inputs
{
    my $self = {};
    my $data = { key => 'value' };
    my $filename = 'test.xml';

    my $result = eval { XML::Simple::cache_write_memshare($self, $data, $filename) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(defined $result, 'Function returns result');
        is($MemShareCache{$filename}[0], time(), 'Timestamp is set correctly');
        is_deeply($MemShareCache{$filename}[1], $data, 'Data is cached correctly');
    }
}

# Test case 2: Edge case with undef filename
{
    my $self = {};
    my $data = { key => 'value' };
    my $filename = undef;

    my $result = eval { XML::Simple::cache_write_memshare($self, $data, $filename) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(defined $result, 'Function returns result');
        is(scalar keys %MemShareCache, 0, 'No data cached when filename is undef');
    }
}

# Test case 3: Edge case with empty filename
{
    my $self = {};
    my $data = { key => 'value' };
    my $filename = '';

    my $result = eval { XML::Simple::cache_write_memshare($self, $data, $filename) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(defined $result, 'Function returns result');
        is(scalar keys %MemShareCache, 0, 'No data cached when filename is empty');
    }
}

# Test case 4: Edge case with undef data
{
    my $self = {};
    my $data = undef;
    my $filename = 'test.xml';

    my $result = eval { XML::Simple::cache_write_memshare($self, $data, $filename) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(defined $result, 'Function returns result');
        is(scalar keys %MemShareCache, 0, 'No data cached when data is undef');
    }
}

# Test case 5: Edge case with empty data
{
    my $self = {};
    my $data = {};
    my $filename = 'test.xml';

    my $result = eval { XML::Simple::cache_write_memshare($self, $data, $filename) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(defined $result, 'Function returns result');
        is($MemShareCache{$filename}[0], time(), 'Timestamp is set correctly');
        is_deeply($MemShareCache{$filename}[1], $data, 'Empty data is cached correctly');
    }
}

done_testing();
