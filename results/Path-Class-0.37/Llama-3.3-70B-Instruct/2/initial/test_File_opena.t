use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::opena"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'opena is defined'); }

# Test case 1: Successful append operation
my ($fh, $filename) = tempfile();
my $file = Path::Class::File->new($filename);
my $result = eval { $file->opena() };
if ($@) { fail('opena crashed: ' . $@); } else { ok(defined $result, 'opena returns a filehandle'); }

# Test case 2: Append operation to a non-existent file
my $non_existent_file = Path::Class::File->new('non_existent_file.txt');
my $result2 = eval { $non_existent_file->opena() };
if ($@) { fail('opena crashed: ' . $@); } else { ok(defined $result2, 'opena creates a new file'); }

# Test case 3: Append operation to a file with no write permission
my $temp_dir = tempdir();
my $no_write_file = Path::Class::File->new($temp_dir . '/no_write_file.txt');
my $fh3 = IO::File->new($no_write_file, 'w');
$fh3->close();
chmod 0444, $no_write_file;
my $result3 = eval { $no_write_file->opena() };
if ($@) { like($@, qr/Permission denied/, 'opena fails with permission denied error'); } else { fail('Expected opena to fail with permission denied error'); }

# Clean up resources
unlink $filename;
rmdir $temp_dir;

done_testing();
