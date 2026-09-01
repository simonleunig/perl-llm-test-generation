use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock unmock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::_strict_mode_for_caller"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, '_strict_mode_for_caller is defined'); }

# Mock the $StrictMode hash
my %StrictMode;
mock 'XML::Simple::StrictMode', \%StrictMode;

# Test case 1: No arguments provided
my $result = eval { XML::Simple::_strict_mode_for_caller() };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'Function returns result when no arguments are provided');
    is($result, 0, 'Strict mode is 0 when no arguments are provided');
}

# Test case 2: Set strict mode to 1
$result = eval { XML::Simple::_strict_mode_for_caller(1) };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'Function returns result when setting strict mode to 1');
    is($result, 1, 'Strict mode is 1 when set to 1');
    is($StrictMode{caller(0)}, 1, 'Strict mode is set for the caller');
}

# Test case 3: Set strict mode to 0
$result = eval { XML::Simple::_strict_mode_for_caller(0) };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'Function returns result when setting strict mode to 0');
    is($result, 0, 'Strict mode is 0 when set to 0');
    is($StrictMode{caller(0)}, 0, 'Strict mode is set for the caller');
}

# Test case 4: Calling from XML::Simple itself
mock 'caller', sub { return ('XML::Simple', undef) };
$result = eval { XML::Simple::_strict_mode_for_caller(1) };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, 'Function returns result when called from XML::Simple');
    is($result, 0, 'Strict mode is 0 when called from XML::Simple');
}

# Clean up mocks
unmock 'XML::Simple::StrictMode';
unmock 'caller';

done_testing();