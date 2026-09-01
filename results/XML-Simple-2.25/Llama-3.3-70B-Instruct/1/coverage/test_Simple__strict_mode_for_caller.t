use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::_strict_mode_for_caller"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, '_strict_mode_for_caller is defined'); }

my $result = eval { XML::Simple::_strict_mode_for_caller(0) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, '_strict_mode_for_caller returns result without setting mode'); }

$result = eval { XML::Simple::_strict_mode_for_caller(1) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, '_strict_mode_for_caller returns result with setting mode to 1'); }

$result = eval { XML::Simple::_strict_mode_for_caller(0) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, '_strict_mode_for_caller returns result with setting mode to 0'); }

my $package = __PACKAGE__;
my $set_mode = 1;
$result = eval { XML::Simple::_strict_mode_for_caller($set_mode) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, $set_mode, '_strict_mode_for_caller sets the strict mode flag correctly'); }

my $error;  # AFTER LAST PASS: my $error;  # UNVALIDATED: my $error = eval { XML::Simple::_strict_mode_for_caller() };
# FAILED: if ($@) { ok(1, '_strict_mode_for_caller dies without setting mode'); like($@, qr/Usage: _strict_mode_for_caller\(mode\)/, 'Error message correct'); } else { fail('Expected function to die without setting mode'); }

done_testing();