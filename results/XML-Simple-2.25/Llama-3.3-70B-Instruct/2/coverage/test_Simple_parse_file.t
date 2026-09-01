use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::parse_file"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'parse_file is defined'); }

# Test case 1: Test with a valid XML file
my ($fh, $filename) = tempfile();
print $fh '<root><person><name>John</name><age>30</age></person></root>';
close $fh;
my $result = eval { XML::Simple->new()->parse_file($filename) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result with valid XML file'); }
unlink $filename;

# Test case 2: Test with an invalid XML file
($fh, $filename) = tempfile();
print $fh '<root><person><name>John</name><age>30</age>';
close $fh;
$result = eval { XML::Simple->new()->parse_file($filename) };
if ($@) { ok($@, 'Function crashes with invalid XML file'); } else { fail('Function did not crash with invalid XML file'); }
unlink $filename;

# Test case 3: Test with a non-existent file
$result = eval { XML::Simple->new()->parse_file('non_existent_file.xml') };
if ($@) { ok($@, 'Function crashes with non-existent file'); } else { fail('Function did not crash with non-existent file'); }

# Test case 4: Test with cache option enabled
($fh, $filename) = tempfile();
print $fh '<root><person><name>John</name><age>30</age></person></root>';
close $fh;
my $simple = XML::Simple->new();
$simple->{opt}->{cache} = ['Storable'];
$result = eval { $simple->parse_file($filename) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result with cache option enabled'); }
# AFTER LAST PASS: unlink $filename;

done_testing();
