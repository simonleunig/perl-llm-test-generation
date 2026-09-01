use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::new"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'new is defined'); }

# Test case: Valid options
my $result = eval { XML::Simple->new(key => 'value') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result with valid options'); }

# Test case: Invalid options (odd number)
my $odd_result = eval { XML::Simple->new(key => 'value', 'extra') };
if ($@) { like($@, qr/Default options must be name=>value pairs/, 'Correct error message for odd number of options'); } else { fail('Expected function to crash with odd number of options'); }

# Test case: Unrecognized option
my $unrecognized_result = eval { XML::Simple->new(invalid => 'value') };
if ($@) { like($@, qr/Unrecognised option: invalid/, 'Correct error message for unrecognized option'); } else { fail('Expected function to crash with unrecognized option'); }

# Test case: No options
my $no_options_result = eval { XML::Simple->new() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $no_options_result, 'Function returns result with no options'); }

# Test case: Strict mode option not provided
my $strict_mode_result = eval { XML::Simple->new() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $strict_mode_result, 'Function returns result when strict mode option is not provided'); }

done_testing();
