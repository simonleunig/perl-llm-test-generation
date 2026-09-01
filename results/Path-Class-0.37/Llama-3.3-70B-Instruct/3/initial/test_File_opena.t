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

# Create a temporary file
my ($fh, $filename) = tempfile(UNLINK => 1);
close $fh;

# Create a Path::Class::File object
my $file = Path::Class::File->new($filename);

# Test successful append operation
my $result = eval { $file->opena(); };
if ($@) { fail('Append operation crashed: ' . $@); } else { ok(defined $result, 'Append operation successful'); }

# Test append operation with non-existent file
my $non_existent_file = Path::Class::File->new('non_existent_file.txt');
$result = eval { $non_existent_file->opena(); };
if ($@) { like($@, qr/Cannot append/, 'Append operation to non-existent file fails'); } else { fail('Append operation to non-existent file did not fail'); }

# Test append operation with file that cannot be written to
my $unreadable_file = Path::Class::File->new($filename);
chmod 0444, $filename;  # Make the file unreadable
$result = eval { $unreadable_file->opena(); };
if ($@) { like($@, qr/Permission denied/, 'Append operation to unreadable file fails'); } else { fail('Append operation to unreadable file did not fail'); }
chmod 0644, $filename;  # Restore the file's permissions

done_testing();
