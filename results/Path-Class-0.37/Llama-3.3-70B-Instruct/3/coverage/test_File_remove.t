use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::remove"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'remove is defined'); }

# Test case 1: Remove existing file
my ($fh, $filename) = tempfile();
eval { Path::Class::File->new($filename)->remove() };
if ($@) { fail('Remove existing file crashed: ' . $@); } else { ok(! -e $filename, 'Existing file removed'); }

# Test case 2: Remove non-existent file
my $non_existent_file = File::Spec->catfile(tempdir(), 'non_existent_file');
eval { Path::Class::File->new($non_existent_file)->remove() };
if ($@) { fail('Remove non-existent file crashed: ' . $@); } else { ok(1, 'Non-existent file removal does not crash'); }

# Test case 3: Remove file with permissions issue
my ($perm_fh, $perm_filename) = tempfile();
chmod 0444, $perm_filename; # Make file read-only
eval { Path::Class::File->new($perm_filename)->remove() };
if ($@) { fail('Remove file with permissions issue crashed: ' . $@); } else { ok(! -e $perm_filename, 'File with permissions issue removed'); }
# AFTER LAST PASS: chmod 0644, $perm_filename; # Restore original permissions

done_testing();
