use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::stringify"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'stringify is defined'); }

my $dir = Path::Class::Dir->new('t', 'test');
my $result = eval { $dir->stringify() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }
is($result, File::Spec->catdir('t', 'test'), 'Correct directory path');

$dir = Path::Class::Dir->new('');
$result = eval { $dir->stringify() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }
is($result, '/', 'Empty directory path');

$dir = Path::Class::Dir->new('t~est', 't?est');
$result = eval { $dir->stringify() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }
is($result, File::Spec->catdir('t~est', 't?est'), 'Directory path with special characters');

$dir = Path::Class::Dir->new('tést', 't?ést');
$result = eval { $dir->stringify() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }
is($result, File::Spec->catdir('tést', 't?ést'), 'Directory path with non-ASCII characters');

done_testing();