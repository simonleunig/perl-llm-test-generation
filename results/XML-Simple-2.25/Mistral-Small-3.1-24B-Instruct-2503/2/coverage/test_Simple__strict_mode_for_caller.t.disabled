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
    ok(defined $result, '_strict_mode_for_caller returns defined value when no arguments are provided');
    is($result, 0, 'Strict mode is off by default');
}

# Test case 2: Setting strict mode to 1
$result = eval { XML::Simple::_strict_mode_for_caller(1) };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, '_strict_mode_for_caller returns defined value when setting strict mode to 1');
    is($result, 1, 'Strict mode is set to 1');
    is($StrictMode{caller(0)}, 1, 'Strict mode is set for the calling package');
}

# Test case 3: Setting strict mode to 0
$result = eval { XML::Simple::_strict_mode_for_caller(0) };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, '_strict_mode_for_caller returns defined value when setting strict mode to 0');
    is($result, 0, 'Strict mode is set to 0');
    is($StrictMode{caller(0)}, 0, 'Strict mode is set to 0 for the calling package');
}

# Test case 4: Calling from XML::Simple itself
mock 'XML::Simple::caller', sub { return 'XML::Simple' };
$result = eval { XML::Simple::_strict_mode_for_caller(1) };
if ($@) { fail('Function crashed: ' . $@); } else {
    ok(defined $result, '_strict_mode_for_caller returns defined value when called from XML::Simple');
    is($result, 0, 'Strict mode is not set when called from XML::Simple');
}

# Clean up mocks
unmock 'XML::Simple::StrictMode';
unmock 'XML::Simple::caller';

done_testing();