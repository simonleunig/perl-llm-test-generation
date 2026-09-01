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

# Mock the global %MemShareCache hash
my %MemShareCache;
mock 'XML::Simple::MemShareCache', \%MemShareCache;

# Test case 1: Normal operation with valid inputs
{
    my $self = {};
    my $data = { key => 'value' };
    my $filename = 'test.xml';

    my $result = eval { XML::Simple::cache_write_memshare($self, $data, $filename) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(defined $MemShareCache{$filename}, 'Data is cached');
        is($MemShareCache{$filename}[0], time(), 'Timestamp is correct');
        is_deeply($MemShareCache{$filename}[1], $data, 'Data is correct');
    }
}

# Test case 2: Edge case with undef filename
{
    my $self = {};
    my $data = { key => 'value' };
    my $filename = undef;

    my $result = eval { XML::Simple::cache_write_memshare($self, $data, $filename) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(!defined $MemShareCache{$filename}, 'Data is not cached with undef filename');
    }
}

# Test case 3: Edge case with empty filename
{
    my $self = {};
    my $data = { key => 'value' };
    my $filename = '';

    my $result = eval { XML::Simple::cache_write_memshare($self, $data, $filename) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(!defined $MemShareCache{$filename}, 'Data is not cached with empty filename');
    }
}

# Test case 4: Edge case with undef data
{
    my $self = {};
    my $data = undef;
    my $filename = 'test.xml';

    my $result = eval { XML::Simple::cache_write_memshare($self, $data, $filename) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(!defined $MemShareCache{$filename}, 'Data is not cached with undef data');
    }
}

# Test case 5: Edge case with empty data
{
    my $self = {};
    my $data = {};
    my $filename = 'test.xml';

    my $result = eval { XML::Simple::cache_write_memshare($self, $data, $filename) };
    if ($@) { fail('Function crashed: ' . $@); } else {
        ok(defined $MemShareCache{$filename}, 'Data is cached with empty data');
        is_deeply($MemShareCache{$filename}[1], $data, 'Empty data is correct');
    }
}

done_testing();
