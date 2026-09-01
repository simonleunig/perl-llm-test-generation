use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::basename"} };
if ($@) { fail("Symbol check crashed: $@"); } else { ok($symbol_check, 'basename is defined'); }

my $dir1 = Path::Class::Dir->new();
my $result1 = eval { $dir1->basename() };
if ($@) { fail('basename crashed on empty path: ' . $@); } else { is($result1, undef, 'basename returns undef for empty path'); }

my $dir2 = Path::Class::Dir->new('/');
my $result2 = eval { $dir2->basename() };
if ($@) { fail('basename crashed on single directory: ' . $@); } else { is($result2, '', 'basename returns empty string for single directory'); }

my $dir3 = Path::Class::Dir->new('path', 'to', 'directory');
my $result3 = eval { $dir3->basename() };
if ($@) { fail('basename crashed on normal path: ' . $@); } else { is($result3, 'directory', 'basename returns last directory name for normal path'); }

my $dir4 = Path::Class::Dir->new();
my $error = eval { $dir4->basename() };
ok(!defined $error, "Doesn't die with empty path");

done_testing();