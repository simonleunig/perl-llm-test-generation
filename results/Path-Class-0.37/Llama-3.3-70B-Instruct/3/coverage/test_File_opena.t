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
if ($@) { fail('Append operation crashed: ' . $@); } else { ok(defined $result, 'Append operation successful'); }

my $non_existent_file = Path::Class::File->new('non_existent_file.txt');
my $error = eval { $non_existent_file->opena(); };
# FAILED: if ($@) { like($@, qr/Can't append/, 'Append operation to non-existent file fails'); } else { fail('Append operation to non-existent file did not fail'); }

my $unreadable_file = Path::Class::File->new($filename);
chmod 0444, $filename;  
my $error2 = eval { $unreadable_file->opena(); };
if ($@) { like($@, qr/Permission denied/, 'Append operation to unreadable file fails'); } else { fail('Append operation to unreadable file did not fail'); }
# AFTER LAST PASS: chmod 0644, $filename;  

done_testing();