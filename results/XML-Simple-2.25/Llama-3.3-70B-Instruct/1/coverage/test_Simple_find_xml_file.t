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

my $temp_file = tempfile();
my $result = eval { XML::Simple->find_xml_file($temp_file) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for existing file'); }
unlink($temp_file);

my $non_existent_file = 'non_existent_file.xml';
my $error = eval { XML::Simple->find_xml_file($non_existent_file) };
if ($@) { like($@, qr/File does not exist/, 'Function throws error for non-existent file'); } else { fail('Function did not throw error for non-existent file'); }

my $temp_dir = tempdir();
my $temp_file_in_dir = File::Spec->catfile($temp_dir, 'existing_file.xml');
open(my $fh, '>', $temp_file_in_dir) or die $!;
close($fh);
$result = eval { XML::Simple->find_xml_file('existing_file.xml', $temp_dir) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for existing file in search path'); }
unlink($temp_file_in_dir);
rmdir($temp_dir);

$non_existent_file = 'non_existent_file.xml';
$error = eval { XML::Simple->find_xml_file($non_existent_file, $temp_dir) };
if ($@) { like($@, qr/Could not find/, 'Function throws error for non-existent file in search path'); } else { fail('Function did not throw error for non-existent file in search path'); }

done_testing();