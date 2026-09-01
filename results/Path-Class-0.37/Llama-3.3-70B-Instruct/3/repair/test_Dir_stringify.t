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

my $empty_dir = Path::Class::Dir->new();
my $empty_result = eval { $empty_dir->stringify() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $empty_result, 'Function returns result'); }
is($empty_result, '', 'Empty directory path');

my $volume_dir = Path::Class::Dir->new('C:', 'test');
my $volume_result = eval { $volume_dir->stringify() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $volume_result, 'Function returns result'); }
is($volume_result, 'C:test', 'Correct directory path with volume');

done_testing();