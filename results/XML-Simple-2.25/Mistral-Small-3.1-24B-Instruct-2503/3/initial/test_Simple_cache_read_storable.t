use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use Scalar::Util qw(looks_like_number);
use lib '.';
BEGIN { require XML::Simple; }

# Mock the necessary dependencies
mock 'Storable' => (
    retrieve => sub { return 'mocked_data' },
    lock_retrieve => sub { return 'mocked_data' },
);

# Mock the XML::Simple object methods
mock 'XML::Simple' => (
    storable_filename => sub { return 'mocked_cache_file' },
);

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::cache_read_storable"} };
if ($@) {
    fail('Symbol check crashed: ' . $@);
} else {
    ok($symbol_check, 'cache_read_storable is defined');
}

# Create a temporary directory and files
my $tempdir = tempdir(CLEANUP => 1);
my ($fh, $filename) = tempfile(DIR => $tempdir);
my ($cache_fh, $cache_filename) = tempfile(DIR => $tempdir);

# Write some data to the XML file
print $fh "dummy xml data\n";
close($fh);

# Write some data to the cache file
print $cache_fh "dummy cache data\n";
close($cache_fh);

# Make the cache file older than the XML file
utime undef, undef, $cache_filename;

# Test case: Cache file does not exist
my $self = bless({}, 'XML::Simple');
my $result = eval { XML::Simple::cache_read_storable($self, $filename) };
if ($@) {
    fail('Function crashed: ' . $@);
} else {
    ok(!defined $result, 'Function returns undef when cache file does not exist');
}

# Make the cache file readable and more recent than the XML file
utime undef, undef, $filename;
utime undef, undef, $cache_filename;

# Test case: Cache file is readable and more recent
$result = eval { XML::Simple::cache_read_storable($self, $filename) };
if ($@) {
    fail('Function crashed: ' . $@);
} else {
    is($result, 'mocked_data', 'Function returns cached data when cache file is more recent');
}

# Test case: Operating system is VMS
local $^O = 'VMS';
$result = eval { XML::Simple::cache_read_storable($self, $filename) };
if ($@) {
    fail('Function crashed: ' . $@);
} else {
    is($result, 'mocked_data', 'Function returns cached data on VMS');
}

# Test case: Operating system is not VMS
local $^O = 'Linux';
$result = eval { XML::Simple::cache_read_storable($self, $filename) };
if ($@) {
    fail('Function crashed: ' . $@);
} else {
    is($result, 'mocked_data', 'Function returns cached data on non-VMS');
}

done_testing();
