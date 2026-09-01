use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::parent"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'parent is defined'); }

# Test case 1: Absolute directory
my $abs_dir = Path::Class::Dir->new('/absolute/path');
my $result = eval { $abs_dir->parent };
if ($@) { fail('Absolute directory parent crashed: ' . $@); } else { ok(defined $result, 'Absolute directory parent returns result'); }
is($result->dir_list, ['/absolute'], 'Absolute directory parent returns correct result');

# Test case 2: Current directory
my $cur_dir = Path::Class::Dir->new('.');
my $result2 = eval { $cur_dir->parent };
if ($@) { fail('Current directory parent crashed: ' . $@); } else { ok(defined $result2, 'Current directory parent returns result'); }
is($result2->dir_list, ['..'], 'Current directory parent returns correct result');

# Test case 3: Relative directory with multiple directories
my $rel_dir = Path::Class::Dir->new('relative/path');
my $result3 = eval { $rel_dir->parent };
if ($@) { fail('Relative directory parent crashed: ' . $@); } else { ok(defined $result3, 'Relative directory parent returns result'); }
is($result3->dir_list, ['relative'], 'Relative directory parent returns correct result');

# Test case 4: Relative directory with only parent directories
my $rel_dir2 = Path::Class::Dir->new('..');
my $result4 = eval { $rel_dir2->parent };
if ($@) { fail('Relative directory parent crashed: ' . $@); } else { ok(defined $result4, 'Relative directory parent returns result'); }
is($result4->dir_list, ['..', '..'], 'Relative directory parent returns correct result');

# Test case 5: Single directory
my $single_dir = Path::Class::Dir->new('single');
my $result5 = eval { $single_dir->parent };
if ($@) { fail('Single directory parent crashed: ' . $@); } else { ok(defined $result5, 'Single directory parent returns result'); }
is($result5->dir_list, [''], 'Single directory parent returns correct result');

done_testing();
