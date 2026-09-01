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
my $result = eval { $file->touch() };
if ($@) { fail('touch crashed: ' . $@); } else { ok(1, 'touch succeeds when file exists'); }

# Test case: File does not exist
unlink $filename;
my $non_existent_file = Path::Class::File->new($filename);
$result = eval { $non_existent_file->touch() };
if ($@) { fail('touch crashed: ' . $@); } else { ok(-f $filename, 'touch creates file when it does not exist'); }

# Clean up
unlink $filename;

done_testing();
