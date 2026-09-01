use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::traverse"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'traverse is defined'); }

my $temp_dir = tempdir(CLEANUP => 1);
my $dir = Path::Class::Dir->new($temp_dir);

my $result = eval { $dir->traverse(sub { 1 }, 'arg1', 'arg2') };
if ($@) { fail('traverse crashed: ' . $@); } else { ok(defined $result, 'traverse returns result'); }

my $empty_dir = tempdir(CLEANUP => 1);
my $empty_dir_obj = Path::Class::Dir->new($empty_dir);
$result = eval { $empty_dir_obj->traverse(sub { 1 }, 'arg1', 'arg2') };
if ($@) { fail('traverse crashed: ' . $@); } else { ok(defined $result, 'traverse returns result for empty directory'); }

my $non_existent_dir = 'non_existent_dir';
my $non_existent_dir_obj = Path::Class::Dir->new($non_existent_dir);
my $error = eval { $non_existent_dir_obj->traverse(sub { 1 }, 'arg1', 'arg2') };
if ($@) { like($@, qr/No such file or directory/, 'traverse throws error for non-existent directory'); } else { fail('traverse did not throw error for non-existent directory'); }

done_testing();