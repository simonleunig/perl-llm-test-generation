use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::touch"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'touch is defined'); }

# Create a temporary file
my ($fh, $filename) = tempfile();
close $fh;

# Test case: File exists
my $file = Path::Class::File->new($filename);
my $result = eval { $file->touch };
if ($@) { fail('touch crashed on existing file: ' . $@); } else { ok(1, 'touch succeeds on existing file'); }

# Test case: File does not exist
my $non_existent_file = Path::Class::File->new('non_existent_file.txt');
$result = eval { $non_existent_file->touch };
if ($@) { fail('touch crashed on non-existent file: ' . $@); } else { ok(-e 'non_existent_file.txt', 'touch creates non-existent file'); }

# Clean up
# AFTER LAST PASS: unlink $filename;
# AFTER LAST PASS: unlink 'non_existent_file.txt';

done_testing();
