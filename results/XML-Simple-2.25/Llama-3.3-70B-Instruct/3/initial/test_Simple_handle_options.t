use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::handle_options"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'handle_options is defined'); }

# Test case 1: Valid options
my $xml_simple = bless({}, 'XML::Simple');
my $result = eval { $xml_simple->handle_options('in', 'rootname' => 'root', 'forcearray' => 1) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result with valid options'); }

# Test case 2: Invalid option
$result = eval { $xml_simple->handle_options('in', 'invalid_option' => 'value') };
if ($@) { like($@, qr/Unrecognised option: invalid_option/, 'Function throws error with invalid option'); } else { fail('Function did not throw error with invalid option'); }

# Test case 3: Missing value for option
$result = eval { $xml_simple->handle_options('in', 'rootname') };
if ($@) { like($@, qr/Options must be name=\>value pairs/, 'Function throws error with missing value for option'); } else { fail('Function did not throw error with missing value for option'); }

# Test case 4: ForceArray option with regex
$result = eval { $xml_simple->handle_options('in', 'forcearray' => qr//) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result with ForceArray option as regex'); }

# Test case 5: KeyAttr option with hashref
$result = eval { $xml_simple->handle_options('in', 'keyattr' => { 'elem' => '+attr' }) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result with KeyAttr option as hashref'); }

done_testing();
