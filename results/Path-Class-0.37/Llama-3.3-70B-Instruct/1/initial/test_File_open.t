use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::open"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'open is defined'); }

# Test case 1: Successful file open
my ($fh, $filename) = tempfile();
my $file = Path::Class::File->new($filename);
my $result = eval { $file->open('r') };
if ($@) { fail('Open crashed: ' . $@); } else { ok(defined $result, 'Open returns result'); }
unlink($filename);

# Test case 2: Failed file open (non-existent file)
my $non_existent_file = Path::Class::File->new('non_existent_file.txt');
$result = eval { $non_existent_file->open('r') };
if ($@) { fail('Open crashed: ' . $@); } else { ok(!defined $result, 'Open returns undef for non-existent file'); }

# Test case 3: Failed file open (invalid mode)
my $existing_file = Path::Class::File->new($filename);
$result = eval { $existing_file->open('invalid_mode') };
if ($@) { fail('Open crashed: ' . $@); } else { ok(!defined $result, 'Open returns undef for invalid mode'); }
unlink($filename);

done_testing();
