use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::openw"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'openw is defined'); }

# Test case 1: Successful file opening
my ($fh, $filename) = tempfile();
my $file = Path::Class::File->new($filename);
my $result = eval { $file->openw() };
if ($@) { fail('openw crashed: ' . $@); } else { ok(defined $result, 'openw returns a filehandle'); }
close $fh;
unlink $filename;

# Test case 2: Error handling - file cannot be opened for writing
my $non_writable_file = Path::Class::File->new('/non/existent/file');
my $error_result = eval { $non_writable_file->openw() };
if ($@) { like($@, qr/Can't write to/, 'openw error message is correct'); } else { fail('openw did not throw an exception'); }

# Test case 3: Edge case - file is a directory
my $temp_dir = tempdir();
my $dir_file = Path::Class::File->new($temp_dir);
my $dir_error_result = eval { $dir_file->openw() };
if ($@) { like($@, qr/Can't write to/, 'openw error message is correct for directory'); } else { fail('openw did not throw an exception for directory'); }
# AFTER LAST PASS: rmdir $temp_dir;

done_testing();
