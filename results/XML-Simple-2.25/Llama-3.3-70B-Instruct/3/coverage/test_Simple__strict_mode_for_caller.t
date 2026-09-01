use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::_strict_mode_for_caller"} };
if ($@) { fail("Symbol check crashed: $@"); } else { ok($symbol_check, "_strict_mode_for_caller is defined"); }

my $result = eval { XML::Simple::_strict_mode_for_caller() };
# FAILED: if ($@) { fail("Function crashed: $@"); } else { ok(defined $result, "_strict_mode_for_caller returns result with no arguments"); }

$result = eval { XML::Simple::_strict_mode_for_caller(1) };
if ($@) { fail("Function crashed: $@"); } else { ok(defined $result, "_strict_mode_for_caller returns result with set_mode argument"); }

$result = eval { XML::Simple::_strict_mode_for_caller(1) };
if ($@) { fail("Function crashed: $@"); } else { ok(defined $result, "_strict_mode_for_caller returns result with set_mode argument"); }
$result = eval { XML::Simple::_strict_mode_for_caller() };
if ($@) { fail("Function crashed: $@"); } else { ok(defined $result, "_strict_mode_for_caller returns result without arguments after setting"); }

done_testing();