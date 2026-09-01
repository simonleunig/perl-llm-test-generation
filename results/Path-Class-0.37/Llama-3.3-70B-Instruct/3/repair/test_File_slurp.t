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
if ($@) { fail('slurp crashed: ' . $@); } else { ok(defined $result, 'slurp returns result in scalar context'); }
is($result, "Line 1\nLine 2\nLine 3\n", 'slurp returns correct result in scalar context');

$result = eval { [$file->slurp()] };
if ($@) { fail('slurp crashed: ' . $@); } else { ok(defined $result, 'slurp returns result in list context'); }
is_deeply($result, ["Line 1\n", "Line 2\n", "Line 3\n"], 'slurp returns correct result in list context');

$result = eval { [$file->slurp(chomped => 1)] };
if ($@) { fail('slurp crashed: ' . $@); } else { ok(defined $result, 'slurp returns result with chomp'); }
is_deeply($result, ["Line 1", "Line 2", "Line 3"], 'slurp returns correct result with chomp');

$result = eval { [$file->slurp(split => ',')] };
if ($@) { fail('slurp crashed: ' . $@); } else { ok(defined $result, 'slurp returns result with split'); }
is_deeply($result, [["Line 1"], ["Line 2"], ["Line 3"]], 'slurp returns correct result with split');

my $error = eval { $file->slurp(iomode => 'invalid') };
if ($@) { like($@, qr/invalid/, 'slurp crashes with invalid iomode'); } else { fail('slurp did not crash with invalid iomode'); }

unlink $filename;

done_testing();