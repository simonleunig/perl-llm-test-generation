use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::openr"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'openr is defined'); }

my ($fh, $filename) = tempfile();
my $file = Path::Class::File->new($filename);
my $result = eval { $file->openr() };
if ($@) { fail('openr crashed: ' . $@); } else { ok(defined $result, 'openr returns a filehandle'); }
close $fh;
unlink $filename;

my $non_existent_file = Path::Class::File->new('non_existent_file.txt');
my $error = eval { $non_existent_file->openr() };
if ($@) { like($@, qr/Can't read/, 'openr throws an error for non-existent file'); } else { fail('Expected openr to throw an error'); }

my ($perm_fh, $perm_filename) = tempfile();
chmod 000, $perm_filename;
my $inaccessible_file = Path::Class::File->new($perm_filename);
$error = eval { $inaccessible_file->openr() };
if ($@) { like($@, qr/Can't read/, 'openr throws an error for inaccessible file'); } else { fail('Expected openr to throw an error'); }
chmod 0644, $perm_filename;
unlink $perm_filename;

done_testing();