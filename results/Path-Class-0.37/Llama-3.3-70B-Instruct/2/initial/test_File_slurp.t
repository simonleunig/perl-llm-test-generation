use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::slurp"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'slurp is defined'); }

# Create a temporary file for testing
my ($fh, $filename) = tempfile(UNLINK => 1);
print $fh "Line 1\nLine 2\nLine 3\n";
close $fh;

# Test slurp in scalar context
my $file = Path::Class::File->new($filename);
my $result = eval { $file->slurp() };
if ($@) { fail('Slurp in scalar context crashed: ' . $@); } else { ok(defined $result, 'Slurp in scalar context returns result'); }
is($result, "Line 1\nLine 2\nLine 3\n", 'Slurp in scalar context returns correct result');

# Test slurp in list context
$result = eval { $file->slurp() };
if ($@) { fail('Slurp in list context crashed: ' . $@); } else { ok(defined $result, 'Slurp in list context returns result'); }
is_deeply($result, ["Line 1\n", "Line 2\n", "Line 3\n"], 'Slurp in list context returns correct result');

# Test slurp with chomped option
$result = eval { $file->slurp(chomped => 1) };
if ($@) { fail('Slurp with chomped option crashed: ' . $@); } else { ok(defined $result, 'Slurp with chomped option returns result'); }
is($result, "Line 1Line 2Line 3", 'Slurp with chomped option returns correct result');

# Test slurp with split option in list context
$result = eval { $file->slurp(split => ',') };
if ($@) { fail('Slurp with split option crashed: ' . $@); } else { ok(defined $result, 'Slurp with split option returns result'); }
is_deeply($result, [["Line 1\n"], ["Line 2\n"], ["Line 3\n"]], 'Slurp with split option returns correct result');

# Test slurp with split option in scalar context
$result = eval { $file->slurp(iomode => 'r', split => ',') };
if ($@) { like($@, qr/split argument can only be used in list context/, 'Slurp with split option in scalar context throws correct error'); } else { fail('Slurp with split option in scalar context did not throw error'); }

done_testing();
