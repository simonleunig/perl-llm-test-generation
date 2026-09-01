use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::volume"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'volume is defined'); }

my $file = bless { dir => undef }, 'Path::Class::File';
my $result = eval { $file->volume };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, '', 'volume returns empty string when dir is undefined'); }

my $dir = bless { volume => 'C:' }, 'Path::Class::Dir';
$file = bless { dir => $dir }, 'Path::Class::File';
$result = eval { $file->volume };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'C:', 'volume returns volume of dir when defined'); }

$file = bless { dir => 'not a dir object' }, 'Path::Class::File';
$result = eval { $file->volume };
if ($@) { 
    like($@, qr/Can't locate object method "volume" via package "not a dir object"/, 'volume handles edge case where dir is not a Path::Class::Dir object');
} else { 
    fail('Expected function to crash when dir is not a Path::Class::Dir object');
}

done_testing();