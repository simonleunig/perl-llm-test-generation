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

# Test case: Successful file open
my ($fh, $filename) = tempfile();
my $file = Path::Class::File->new($filename);
my $result = eval { $file->openr() };
if ($@) { fail('openr crashed: ' . $@); } else { ok(defined $result, 'openr returns a filehandle'); }

# Test case: Failed file open (file does not exist)
my $non_existent_file = Path::Class::File->new('non_existent_file.txt');
my $error_result = eval { $non_existent_file->openr() };
if ($@) { like($@, qr/Can't read/, 'openr throws an error for non-existent file'); } else { fail('Expected openr to throw an error'); }

# Test case: Failed file open (permission denied)
my $permission_denied_file = Path::Class::File->new($filename);
chmod 0222, $permission_denied_file; # Make the file unreadable
$error_result = eval { $permission_denied_file->openr() };
if ($@) { like($@, qr/Can't read/, 'openr throws an error for permission denied'); } else { fail('Expected openr to throw an error'); }
chmod 0666, $permission_denied_file; # Restore the file's permissions

done_testing();
