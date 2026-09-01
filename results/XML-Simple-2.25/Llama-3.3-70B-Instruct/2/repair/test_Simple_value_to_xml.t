use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw(tempfile tempdir);
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::value_to_xml"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'value_to_xml is defined'); }

my $simple_hash = { foo => 'bar' };
my $result = eval { XML::Simple->new->value_to_xml($simple_hash, 'root', '') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for simple hashref'); }
is($result, '<root><foo>bar</foo></root>', 'Correct XML output for simple hashref');

my $nested_hash = { foo => { bar => 'baz' } };
$result = eval { XML::Simple->new->value_to_xml($nested_hash, 'root', '') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for nested hashref'); }
is($result, '<root><foo><bar>baz</bar></foo></root>', 'Correct XML output for nested hashref');

my $array_ref = [ 'foo', 'bar' ];
$result = eval { XML::Simple->new->value_to_xml($array_ref, 'root', '') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for arrayref'); }
is($result, '<root><anon>foo</anon><anon>bar</anon></root>', 'Correct XML output for arrayref');

my $circular_hash = { foo => {} };
$circular_hash->{foo} = $circular_hash;
my $error = eval { XML::Simple->new->value_to_xml($circular_hash, 'root', '') };
if ($@) { like($@, qr/circular data structures not supported/, 'Correct error message for circular data structure'); } else { fail('Function did not crash for circular data structure'); }

my $undefined_hash = { foo => undef };
$result = eval { XML::Simple->new->value_to_xml($undefined_hash, 'root', '') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for undefined value'); }
is($result, '<root><foo></foo></root>', 'Correct XML output for undefined value');

done_testing();