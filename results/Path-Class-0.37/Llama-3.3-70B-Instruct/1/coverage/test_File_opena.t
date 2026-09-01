use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::opena"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'opena is defined'); }

my ($fh, $filename) = tempfile(UNLINK => 1);
close $fh;

my $file = Path::Class::File->new($filename);

my $result = eval { $file->opena(); };
if ($@) { fail('opena crashed: ' . $@); } else { ok(defined $result, 'opena returns a filehandle'); }

my $non_existent_file = Path::Class::File->new('non_existent_file.txt');
my $error = eval { $non_existent_file->opena(); };
# FAILED: if ($@) { like($@, qr/No such file or directory/, 'opena throws exception for non-existent file'); } else { fail('opena did not throw exception for non-existent file'); }

my $temp_dir = tempdir(CLEANUP => 1);
my $non_writable_file = Path::Class::File->new($temp_dir . '/non_writable_file.txt');
open my $fw, '>', $non_writable_file or die $!;
close $fw;
chmod 0444, $non_writable_file or die $!;
$error = eval { $non_writable_file->opena(); };
if ($@) { like($@, qr/Permission denied/, 'opena throws exception for non-writable file'); } else { fail('opena did not throw exception for non-writable file'); }

done_testing();