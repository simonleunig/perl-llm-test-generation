use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::openr"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'openr is defined'); }

# Test case: Successful file opening
my ($fh, $filename) = tempfile();
my $file = Path::Class::File->new($filename);
my $result = eval { $file->openr() };
if ($@) { fail('openr crashed: ' . $@); } else { ok(defined $result, 'openr returns result'); }
close $fh;
unlink $filename;

# Test case: File does not exist
my $non_existent_file = Path::Class::File->new('non_existent_file.txt');
my $error = eval { $non_existent_file->openr() };
if ($@) { like($@, qr/Can't read/, 'openr throws error for non-existent file'); } else { fail('openr did not throw error for non-existent file'); }

# Test case: File cannot be read
my ($fh2, $filename2) = tempfile();
my $file2 = Path::Class::File->new($filename2);
chmod 0222, $filename2;  # Make file unreadable
my $error2 = eval { $file2->openr() };
if ($@) { like($@, qr/Can't read/, 'openr throws error for unreadable file'); } else { fail('openr did not throw error for unreadable file'); }
chmod 0666, $filename2;  # Restore file permissions
close $fh2;
unlink $filename2;

done_testing();
