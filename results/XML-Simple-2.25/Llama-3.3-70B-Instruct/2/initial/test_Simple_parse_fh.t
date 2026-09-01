use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::parse_fh"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'parse_fh is defined'); }

# Test case 1: Valid filehandle
my ($fh, $filename) = tempfile();
print $fh '<root><person><name>John</name></person></root>';
seek $fh, 0, 0;
my $result = eval { XML::Simple->new()->parse_fh($fh) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result with valid filehandle'); }

# Test case 2: Invalid filehandle (string)
my $result2 = eval { XML::Simple->new()->parse_fh('string') };
if ($@) { like($@, qr/Can't use string \("string"\) as a filehandle/, 'Correct error message for string filehandle'); } else { fail('Expected function to crash with string filehandle'); }

# Test case 3: Invalid filehandle (undef)
my $result3 = eval { XML::Simple->new()->parse_fh(undef) };
if ($@) { like($@, qr/Can't use undef as a filehandle/, 'Correct error message for undef filehandle'); } else { fail('Expected function to crash with undef filehandle'); }

# Test case 4: Empty filehandle
my ($fh2, $filename2) = tempfile();
my $result4 = eval { XML::Simple->new()->parse_fh($fh2) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result4, 'Function returns result with empty filehandle'); }

done_testing();
