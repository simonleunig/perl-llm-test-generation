use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::remove"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'remove is defined'); }

my ($fh, $filename) = tempfile();
close $fh;
unlink $filename;
my $file = Path::Class::File->new($filename);
my $result = eval { $file->remove() };
if ($@) { fail('Remove non-existent file crashed: ' . $@); } else { ok(!$result, 'Remove non-existent file returns false'); }

($fh, $filename) = tempfile();
close $fh;
$file = Path::Class::File->new($filename);
$result = eval { $file->remove() };
if ($@) { fail('Remove existing file crashed: ' . $@); } else { ok($result, 'Remove existing file returns true'); }

# AFTER LAST PASS: ($fh, $filename) = tempfile();
# AFTER LAST PASS: close $fh;
# AFTER LAST PASS: chmod 0444, $filename;
# UNVALIDATED: $file = Path::Class::File->new($filename);
# UNVALIDATED: $result = eval { $file->remove() };
# FAILED: if ($@) { fail('Remove file with permissions issue crashed: ' . $@); } else { ok(!$result, 'Remove file with permissions issue returns false'); }

done_testing();