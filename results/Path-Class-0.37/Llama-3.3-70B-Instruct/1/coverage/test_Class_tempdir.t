use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::tempdir"} };
if ($@) { fail("Symbol check crashed: $@"); } else { ok($symbol_check, "tempdir is defined"); }

my $result = eval { Path::Class::tempdir() };
if ($@) { fail("Function crashed: $@"); } else { ok(defined $result, "Function returns result"); }

$result = eval { Path::Class::tempdir() };
if ($@) { fail("Function crashed: $@"); } else { ok($result->isa('Path::Class::Dir'), "Returned object is an instance of Path::Class::Dir"); }

$result = eval { Path::Class::tempdir() };
if ($@) { fail("Function crashed: $@"); } else { ok(-d $result->stringify, "Temporary directory exists"); }

my $mock;
eval { require File::Temp; };
if ($@) {
    # DEPENDENCY MISSING: File::Temp - mock skipped
} else {
    no strict 'refs';
    if (defined &{"File::Temp::tempdir"}) {
        $mock = mock 'File::Temp' => (override => [tempdir => sub { return undef }]);
    } else {
        $mock = mock 'File::Temp' => (add => [tempdir => sub { return undef }]);
    }
}

$result = eval { Path::Class::tempdir() };
if ($@) { fail("Function crashed: $@"); } else { ok(!defined $result, "Function returns undef when File::Temp::tempdir fails"); }

done_testing();