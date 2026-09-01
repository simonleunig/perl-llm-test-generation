use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::end_element"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'end_element is defined'); }

# Test case 1: Normal operation
my $simple = bless { curlist => [], lists => [[1], [2]] }, 'XML::Simple';
my $result = eval { $simple->end_element() };
if ($@) { fail('end_element crashed: ' . $@); } else { ok(defined $simple->{curlist}, 'end_element updates curlist'); }

# Test case 2: Edge case - empty lists
my $simple_empty = bless { curlist => [], lists => [] }, 'XML::Simple';
$result = eval { $simple_empty->end_element() };
if ($@) { fail('end_element crashed on empty lists: ' . $@); } else { ok(!defined $simple_empty->{curlist}, 'end_element handles empty lists'); }

# Test case 3: Error handling - invalid object
my $invalid_object = bless { foo => 'bar' }, 'XML::Simple';
$result = eval { $invalid_object->end_element() };
if ($@) { fail('end_element crashed on invalid object: ' . $@); } else { ok(!defined $invalid_object->{curlist}, 'end_element handles invalid object'); }

done_testing();
