use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::parse_fh"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'parse_fh is defined'); }

my ($fh, $filename) = tempfile();
print $fh '<root><person><name>John</name></person></root>';
seek $fh, 0, 0;
my $result = eval { XML::Simple->new()->parse_fh($fh) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result with valid filehandle'); }

my $result2 = eval { XML::Simple->new()->parse_fh('string') };
if ($@) { like($@, qr/Can't use string \("string"\) as a filehandle/, 'Correct error message for string filehandle'); } else { fail('Expected function to crash with string filehandle'); }

my $result3 = eval { XML::Simple->new()->parse_fh(undef) };
if ($@) { like($@, qr/Can't use undef as a filehandle/, 'Correct error message for undef filehandle'); } else { fail('Expected function to crash with undef filehandle'); }

my ($fh2, $filename2) = tempfile();
print $fh2 '<root><person><name>John</name></person></root>';
seek $fh2, 0, 0;
my $result4 = eval { XML::Simple->new()->parse_fh($fh2) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result4, 'Function returns result with non-empty filehandle'); }

my ($fh3, $filename3) = tempfile();
my $result5 = eval { XML::Simple->new()->parse_fh($fh3) };
if ($@) { like($@, qr/no element found/, 'Correct error message for empty filehandle'); } else { fail('Expected function to crash with empty filehandle'); }

done_testing();