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

# Create a temporary file for testing
my ($fh, $filename) = tempfile();
close $fh;

# Test case: stat on an existing file
my $entity = Path::Class::Entity->new($filename);
my $result = eval { $entity->stat() };
if ($@) { fail('stat on existing file crashed: ' . $@); } else { ok(defined $result, 'stat on existing file returns result'); }

# Test case: stat on a non-existent file
my $non_existent_file = 'non_existent_file.txt';
my $non_existent_entity = Path::Class::Entity->new($non_existent_file);
$result = eval { $non_existent_entity->stat() };
if ($@) { fail('stat on non-existent file crashed: ' . $@); } else { ok(!defined $result, 'stat on non-existent file returns undef'); }

# Test case: stat on a directory
my $temp_dir = tempdir();
my $dir_entity = Path::Class::Entity->new($temp_dir);
$result = eval { $dir_entity->stat() };
if ($@) { fail('stat on directory crashed: ' . $@); } else { ok(defined $result, 'stat on directory returns result'); }

# Clean up temporary files and directories
unlink $filename;
rmdir $temp_dir;

done_testing();
