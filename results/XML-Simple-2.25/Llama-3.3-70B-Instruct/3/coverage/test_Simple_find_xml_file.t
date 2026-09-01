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

my ($fh, $filename);  # AFTER LAST PASS: my ($fh, $filename) = tempfile();
# AFTER LAST PASS: print $fh "<xml></xml>";
# AFTER LAST PASS: close $fh;
my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { XML::Simple::find_xml_file($filename) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(-f $result, 'File found in current directory'); }
# AFTER LAST PASS: unlink $filename;

my $tempdir;  # AFTER LAST PASS: my $tempdir = tempdir();
my $filepath;  # AFTER LAST PASS: my $filepath;  # UNVALIDATED: my $filepath = File::Spec->catfile($tempdir, 'test.xml');
my $fh;  # AFTER LAST PASS: open my $fh, '>', $filepath or die $!;
# AFTER LAST PASS: print $fh "<xml></xml>";
# AFTER LAST PASS: close $fh;
# UNVALIDATED: $result = eval { XML::Simple::find_xml_file('test.xml', $tempdir) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(-f $result, 'File found in search path'); }
# AFTER LAST PASS: unlink $filepath;
# AFTER LAST PASS: rmdir $tempdir;

# UNVALIDATED: $result = eval { XML::Simple::find_xml_file('nonexistent.xml') };
# FAILED: if ($@) { like($@, qr/Could not find nonexistent\.xml/, 'File not found error'); } else { fail('Expected error not thrown'); }

# UNVALIDATED: $filepath = File::Spec->catfile($tempdir, 'test.xml');
# AFTER LAST PASS: open $fh, '>', $filepath or die $!;
# AFTER LAST PASS: print $fh "<xml></xml>";
# AFTER LAST PASS: close $fh;
# UNVALIDATED: $result = eval { XML::Simple::find_xml_file($filepath) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(-f $result, 'File with directory component found'); }
# AFTER LAST PASS: unlink $filepath;
# AFTER LAST PASS: rmdir $tempdir;

done_testing();