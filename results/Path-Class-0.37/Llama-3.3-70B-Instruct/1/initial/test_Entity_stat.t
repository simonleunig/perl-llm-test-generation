use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Entity; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Entity::stat"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'stat is defined'); }

# Test case: stat() with existing file
my ($fh, $filename) = tempfile();
my $result = eval { Path::Class::Entity->stat($filename) };
if ($@) { fail('stat() crashed with existing file: ' . $@); } else { ok(defined $result, 'stat() returns result with existing file'); }
unlink($filename);

# Test case: stat() with non-existent file
my $non_existent_file = 'non_existent_file.txt';
my $result_non_existent = eval { Path::Class::Entity->stat($non_existent_file) };
if ($@) { like($@, qr/No such file or directory/, 'stat() raises error with non-existent file'); } else { fail('stat() did not raise error with non-existent file'); }

# Test case: stat() with directory
my $temp_dir = tempdir();
my $result_dir = eval { Path::Class::Entity->stat($temp_dir) };
if ($@) { fail('stat() crashed with directory: ' . $@); } else { ok(defined $result_dir, 'stat() returns result with directory'); }
$rmdir($temp_dir);

done_testing();
