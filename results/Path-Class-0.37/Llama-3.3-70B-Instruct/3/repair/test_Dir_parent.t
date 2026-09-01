use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::parent"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'parent is defined'); }

my $abs_dir = Path::Class::Dir->new('/absolute/path');
my $result = eval { $abs_dir->parent() };
if ($@) { fail('Absolute directory parent crashed: ' . $@); } else { ok(defined $result, 'Absolute directory parent returns result'); }
is($result->dir_list(), ['/absolute'], 'Absolute directory parent has correct path');

my $cur_dir = Path::Class::Dir->new('.');
my $result2 = eval { $cur_dir->parent() };
if ($@) { fail('Current directory parent crashed: ' . $@); } else { ok(defined $result2, 'Current directory parent returns result'); }
is($result2->dir_list(), ['..'], 'Current directory parent has correct path');

my $par_dir = Path::Class::Dir->new('..');
my $result3 = eval { $par_dir->parent() };
if ($@) { fail('Parent directory components only parent crashed: ' . $@); } else { ok(defined $result3, 'Parent directory components only parent returns result'); }
is($result3->dir_list(), ['..', '..'], 'Parent directory components only parent has correct path');

my $single_dir = Path::Class::Dir->new('single');
my $result4 = eval { $single_dir->parent() };
if ($@) { fail('Single component directory parent crashed: ' . $@); } else { ok(defined $result4, 'Single component directory parent returns result'); }
is($result4->dir_list(), [''], 'Single component directory parent has correct path');

my $multi_dir = Path::Class::Dir->new('path/to/directory');
my $result5 = eval { $multi_dir->parent() };
if ($@) { fail('Multi-component directory parent crashed: ' . $@); } else { ok(defined $result5, 'Multi-component directory parent returns result'); }
is($result5->dir_list(), ['path', 'to'], 'Multi-component directory parent has correct path');

done_testing();