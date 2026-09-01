use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::slurp"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'slurp is defined'); }

my ($fh, $filename) = tempfile();
print $fh "Line 1\nLine 2\nLine 3\n";
close $fh;

my $file = Path::Class::File->new($filename);

my $result = eval { $file->slurp() };
if ($@) { fail('Slurp in scalar context crashed: ' . $@); } else { ok(defined $result, 'Slurp in scalar context returns result'); }
is($result, "Line 1\nLine 2\nLine 3\n", 'Slurp in scalar context returns correct result');

$result = eval { $file->slurp() };
if ($@) { fail('Slurp in list context crashed: ' . $@); } else { ok(defined $result, 'Slurp in list context returns result'); }
is_deeply($result, ["Line 1\n", "Line 2\n", "Line 3\n"], 'Slurp in list context returns correct result');

$result = eval { $file->slurp(chomped => 1) };
if ($@) { fail('Slurp with chomp crashed: ' . $@); } else { ok(defined $result, 'Slurp with chomp returns result'); }
is($result, "Line 1\nLine 2\nLine 3", 'Slurp with chomp returns correct result');

$result = eval { $file->slurp(split => ':') };
if ($@) { fail('Slurp with split crashed: ' . $@); } else { ok(defined $result, 'Slurp with split returns result'); }
is_deeply($result, [["Line 1"], ["Line 2"], ["Line 3"]], 'Slurp with split returns correct result');

$result = eval { $file->slurp(iomode => 'invalid') };
if ($@) { like($@, qr/Can't read/, 'Slurp with invalid iomode throws correct error'); } else { fail('Slurp with invalid iomode did not throw error'); }

unlink $filename;

done_testing();