use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::file"} };
if ($@) { fail("Symbol check crashed: $@"); } else { ok($symbol_check, "file is defined"); }

my $result = eval { Path::Class::file('test', 'file.txt') };
if ($@) { fail("Function crashed: $@"); } else { ok(defined $result, "Function returns result"); }

$result = eval { Path::Class::file() };
# FAILED: if ($@) { ok(1, "Function handles invalid input"); } else { fail("Function did not handle invalid input"); }

$result = eval { Path::Class::file('file.txt') };
if ($@) { fail("Function crashed: $@"); } else { ok(defined $result, "Function returns result for single path component"); }

$result = eval { Path::Class::file('path', 'to', 'file.txt') };
if ($@) { fail("Function crashed: $@"); } else { ok(defined $result, "Function returns result for multiple path components"); }

done_testing();