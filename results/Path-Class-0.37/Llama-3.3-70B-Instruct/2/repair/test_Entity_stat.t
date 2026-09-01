use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Entity; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Entity::stat"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'stat is defined'); }

my ($fh, $filename) = tempfile();
my $result = eval { Path::Class::Entity::stat($filename) };
if ($@) { fail('stat with existing file crashed: ' . $@); } else { ok(defined $result, 'stat with existing file returns result'); }
unlink $filename;

my $non_existent_file = 'non_existent_file.txt';
my $result_non_existent = eval { Path::Class::Entity::stat($non_existent_file) };
if ($@) { like($@, qr/No such file or directory/, 'stat with non-existing file returns expected error'); } else { fail('stat with non-existing file did not return expected error'); }

my $temp_dir = tempdir();
my $result_dir = eval { Path::Class::Entity::stat($temp_dir) };
if ($@) { fail('stat with directory crashed: ' . $@); } else { ok(defined $result_dir, 'stat with directory returns result'); }
END { rmdir $temp_dir };

done_testing();