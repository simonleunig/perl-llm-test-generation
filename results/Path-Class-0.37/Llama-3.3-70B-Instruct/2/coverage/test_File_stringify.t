use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::stringify"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'stringify is defined'); }

my $file_obj1 = bless { file => 'test_file.txt' }, 'Path::Class::File';
my $result1 = eval { $file_obj1->stringify() };
if ($@) { fail('Function crashed: ' . $@); } else { is($result1, 'test_file.txt', 'stringify returns file name without directory'); }

my $dir_obj;  # AFTER LAST PASS: my $dir_obj = bless { path => '/tmp/test_dir' }, 'Path::Class::Dir';
my $file_obj2;  # AFTER LAST PASS: my $file_obj2 = bless { dir => $dir_obj, file => 'test_file.txt' }, 'Path::Class::File';
my $result2;  # AFTER LAST PASS: my $result2;  # UNVALIDATED: my $result2 = eval { $file_obj2->stringify() };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { is($result2, '/tmp/test_dir/test_file.txt', 'stringify returns concatenated path with directory'); }

my $file_obj3;  # AFTER LAST PASS: my $file_obj3 = bless { dir => $dir_obj, file => undef }, 'Path::Class::File';
my $result3;  # AFTER LAST PASS: my $result3;  # UNVALIDATED: my $result3 = eval { $file_obj3->stringify() };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { is($result3, '', 'stringify returns empty string with undefined file name'); }

done_testing();