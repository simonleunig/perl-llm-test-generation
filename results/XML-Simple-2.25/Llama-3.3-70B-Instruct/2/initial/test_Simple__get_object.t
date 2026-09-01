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

# Test case 1: No object provided
my $result1 = eval { XML::Simple::_get_object() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result1, '_get_object returns result with no object provided'); }

# Test case 2: Object provided
my $object = XML::Simple->new();
my $result2 = eval { XML::Simple::_get_object($object) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result2, '_get_object returns result with object provided'); }

# Test case 3: Invalid object provided
my $invalid_object = bless {}, 'InvalidClass';
my $result3 = eval { XML::Simple::_get_object($invalid_object) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result3, '_get_object returns result with invalid object provided'); }

# Test case 4: Check if returned object is an instance of XML::Simple
my $result4 = eval { XML::Simple::_get_object() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(UNIVERSAL::isa($result4, 'XML::Simple'), '_get_object returns an instance of XML::Simple'); }

done_testing();
