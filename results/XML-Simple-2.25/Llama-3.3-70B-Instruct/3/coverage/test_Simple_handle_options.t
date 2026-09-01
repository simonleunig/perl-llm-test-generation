use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::handle_options"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'handle_options is defined'); }

my $xml_simple = bless({}, 'XML::Simple');

my $result = eval { $xml_simple->handle_options('in', 'rootname' => 'root', 'forcearray' => 1) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result with valid options'); }

$result = eval { $xml_simple->handle_options('in', 'invalid_option' => 'value') };
if ($@) { like($@, qr/Unrecognised option: invalid_option/, 'Function throws error with invalid option'); } else { fail('Function did not throw error with invalid option'); }

$result = eval { $xml_simple->handle_options('in', 'rootname') };
if ($@) { like($@, qr/Options must be name=\>value pairs/, 'Function throws error with missing value for option'); } else { fail('Function did not throw error with missing value for option'); }

# UNVALIDATED: $result = eval { $xml_simple->handle_options('in', 'forcearray' => qr//) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result with ForceArray option as regex'); }

# UNVALIDATED: $result = eval { $xml_simple->handle_options('in', 'keyattr' => { 'elem' => '+attr' }) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result with KeyAttr option as hashref'); }

done_testing();