use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::dir"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'dir is defined'); }

my $result = eval { Path::Class::dir('foo', 'bar') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'dir returns a result'); }

$result = eval { Path::Class::dir('foo', 'bar') };
if ($@) { fail('Function crashed: ' . $@); } else { ok($result->isa('Path::Class::Dir'), 'dir returns a Path::Class::Dir object'); }

$result = eval { Path::Class::dir('foo', 'bar') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result->stringify, File::Spec->catdir('foo', 'bar'), 'dir returns the correct path'); }

$result = eval { Path::Class::dir() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'dir returns a result with empty input'); }

$result = eval { Path::Class::dir('', 'bar') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'dir returns a result with invalid directory components'); }

done_testing();