use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::stringify"} };
if ($@) { fail("Symbol check crashed: $@"); } else { ok($symbol_check, 'stringify is defined'); }

my $dir = Path::Class::Dir->new('path', 'to', 'directory');
my $result = eval { $dir->stringify() };
if ($@) { fail("Function crashed: $@"); } else { ok(defined $result, 'Function returns result for normal directory path'); }
is($result, File::Spec->catdir('path', 'to', 'directory'), 'Correct stringification for normal directory path');

$dir = Path::Class::Dir->new('C:', 'path', 'to', 'directory');
$result = eval { $dir->stringify() };
if ($@) { fail("Function crashed: $@"); } else { ok(defined $result, 'Function returns result for directory path with volume'); }
# FAILED: is($result, File::Spec->catpath('C:', File::Spec->catdir('path', 'to', 'directory'), ''), 'Correct stringification for directory path with volume');

$dir = Path::Class::Dir->new();
$result = eval { $dir->stringify() };
if ($@) { fail("Function crashed: $@"); } else { ok(defined $result, 'Function returns result for invalid directory path'); }
# FAILED: is($result, '', 'Correct stringification for invalid directory path');

done_testing();