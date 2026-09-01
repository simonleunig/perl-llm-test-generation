use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::subdir"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'subdir is defined'); }

my $dir = eval { Path::Class::Dir->new('test_dir') };
if ($@) { fail('Directory creation crashed: ' . $@); } else { ok(defined $dir, 'Directory object created'); }

my $subdir = eval { $dir->subdir('sub_test_dir') };
if ($@) { fail('Subdirectory creation crashed: ' . $@); } else { ok(defined $subdir, 'Subdirectory object created'); }

my $is_dir_object = eval { $subdir->isa('Path::Class::Dir') };
if ($@) { fail('isa check crashed: ' . $@); } else { ok($is_dir_object, 'Subdirectory is a Path::Class::Dir object'); }

my $deep_subdir = eval { $dir->subdir('level1', 'level2', 'level3') };
if ($@) { fail('Deep subdirectory creation crashed: ' . $@); } else { ok(defined $deep_subdir, 'Deep subdirectory object created'); }

my $is_deep_dir_object = eval { $deep_subdir->isa('Path::Class::Dir') };
if ($@) { fail('isa check crashed: ' . $@); } else { ok($is_deep_dir_object, 'Deep subdirectory is a Path::Class::Dir object'); }

my $temp_dir = eval { tempdir(CLEANUP => 1) };
if ($@) { fail('Temporary directory creation crashed: ' . $@); } else { ok(defined $temp_dir, 'Temporary directory created'); }

my $dir_obj = eval { Path::Class::Dir->new($temp_dir) };
if ($@) { fail('Temporary directory object creation crashed: ' . $@); } else { ok(defined $dir_obj, 'Temporary directory object created'); }

my $remove_result = eval { File::Path::rmdir($temp_dir) };
if ($@) { fail('Temporary directory removal crashed: ' . $@); } else { ok(!defined $@, 'Temporary directory removed'); }

done_testing();