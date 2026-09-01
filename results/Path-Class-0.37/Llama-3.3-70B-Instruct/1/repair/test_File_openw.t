use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::openw"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'openw is defined'); }

my ($fh, $filename) = tempfile();
my $file = Path::Class::File->new($filename);
my $result = eval { $file->openw() };
if ($@) { fail('openw crashed: ' . $@); } else { ok(defined $result, 'openw returns result'); }
unlink($filename);

my $temp_dir = tempdir();
my $file_path = File::Spec->catfile($temp_dir, 'test_file');
open(my $fh, '>', $file_path) or die $!;
close($fh);
my $file_obj = Path::Class::File->new($file_path);
chmod 0444, $file_path; # Make file read-only
my $error_result = eval { $file_obj->openw() };
if ($@) { like($@, qr/Can't write to/, 'openw throws exception on permissions issue'); } else { fail('openw did not throw exception on permissions issue'); }
chmod 0644, $file_path; # Restore file permissions
unlink($file_path);
rmdir($temp_dir);

my $non_existent_file = Path::Class::File->new('non_existent_file');
my $non_existent_result = eval { $non_existent_file->openw() };
if ($@) { like($@, qr/Can't write to/, 'openw throws exception on non-existent file'); } else { fail('openw did not throw exception on non-existent file'); }

done_testing();