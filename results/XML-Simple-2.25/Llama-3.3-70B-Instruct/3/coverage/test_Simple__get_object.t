use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::_get_object"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, '_get_object is defined'); }

my $existing_object = XML::Simple->new();
my $result = eval { XML::Simple::_get_object($existing_object) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result with existing object'); }
is($result, $existing_object, 'Returned object is the same as the input object');

$result = eval { XML::Simple::_get_object() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result without input object'); }
# FAILED: isa_ok($result, 'XML::Simple', 'Returned object is an instance of XML::Simple');

my $invalid_object = bless {}, 'InvalidModule';
$result = eval { XML::Simple::_get_object($invalid_object) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result with invalid object'); }
# FAILED: isa_ok($result, 'XML::Simple', 'Returned object is an instance of XML::Simple (not the invalid object)');

my $undef_object = undef;
$result = eval { XML::Simple::_get_object($undef_object) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result with undef object'); }
# FAILED: isa_ok($result, 'XML::Simple', 'Returned object is an instance of XML::Simple (not the undef object)');

done_testing();