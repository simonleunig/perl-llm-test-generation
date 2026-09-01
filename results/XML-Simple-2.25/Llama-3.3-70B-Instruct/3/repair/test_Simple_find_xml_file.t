use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::find_xml_file"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'find_xml_file is defined'); }

my ($fh, $filename) = tempfile();
print $fh "<xml></xml>";
close $fh;
my $result = eval { XML::Simple::find_xml_file($filename) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(-f $result, 'File found in current directory'); }
unlink $filename;

my $tempdir = tempdir();
my $filepath = File::Spec->catfile($tempdir, 'test.xml');
open my $fh, '>', $filepath or die $!;
print $fh "<xml></xml>";
close $fh;
$result = eval { XML::Simple::find_xml_file('test.xml', $tempdir) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(-f $result, 'File found in search path'); }
unlink $filepath;
rmdir $tempdir;

$result = eval { XML::Simple::find_xml_file('nonexistent.xml') };
if ($@) { like($@, qr/Could not find nonexistent\.xml/, 'File not found error'); } else { fail('Expected error not thrown'); }

$filepath = File::Spec->catfile($tempdir, 'test.xml');
open $fh, '>', $filepath or die $!;
print $fh "<xml></xml>";
close $fh;
$result = eval { XML::Simple::find_xml_file($filepath) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(-f $result, 'File with directory component found'); }
unlink $filepath;
rmdir $tempdir;

done_testing();