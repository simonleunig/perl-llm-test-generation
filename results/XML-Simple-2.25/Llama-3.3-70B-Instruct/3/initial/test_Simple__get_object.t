use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::_get_object"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, '_get_object is defined'); }

# Test case 1: Passing an existing XML::Simple object
my $existing_object = XML::Simple->new();
my $result = eval { XML::Simple::_get_object($existing_object) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result with existing object'); }
is($result, $existing_object, 'Returned object is the same as the input object');

# Test case 2: Not passing an object (create a new one)
$result = eval { XML::Simple::_get_object() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result without input object'); }
isa_ok($result, 'XML::Simple', 'Returned object is an instance of XML::Simple');

# Test case 3: Passing an invalid object
my $invalid_object = bless {}, 'InvalidModule';
$result = eval { XML::Simple::_get_object($invalid_object) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result with invalid object'); }
isa_ok($result, 'XML::Simple', 'Returned object is an instance of XML::Simple (not the invalid object)');

done_testing();
