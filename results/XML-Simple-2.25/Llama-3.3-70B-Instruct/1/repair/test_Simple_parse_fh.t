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

my $result = eval { XML::Simple->parse_fh('invalid') };
if ($@) { like($@, qr/Can't use string/, 'Invalid filehandle error'); } else { fail('Expected error for invalid filehandle'); }

my ($fh, $filename) = tempfile();
print $fh '<root/>' or fail('Failed to write to temporary file');
close $fh or fail('Failed to close temporary file');
open $fh, '<', $filename or fail('Failed to reopen temporary file');
$result = eval { XML::Simple->parse_fh($fh) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for valid filehandle'); }

($fh, $filename) = tempfile();
print $fh '<root><person><name>John</name><age>30</age></person></root>' or fail('Failed to write to temporary file');
close $fh or fail('Failed to close temporary file');
open $fh, '<', $filename or fail('Failed to reopen temporary file');
$result = eval { XML::Simple->parse_fh($fh) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for valid filehandle with XML content'); }

$result = eval { XML::Simple->parse_fh(undef) };
if ($@) { like($@, qr/Can't use undef/, 'Undefined filehandle error'); } else { fail('Expected error for undefined filehandle'); }

done_testing();