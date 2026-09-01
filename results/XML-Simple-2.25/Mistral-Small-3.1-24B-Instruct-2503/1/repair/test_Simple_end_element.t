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

# Mocking the XML::Simple object
my $mock_self = mock('XML::Simple', override => {
    lists => [],
    curlist => undef,
});

# Test case 1: Normal operation with nested elements
$mock_self->{lists} = [['element1'], ['element2']];
$mock_self->{curlist} = 'element2';

my $result = eval { XML::Simple::end_element($mock_self) };
if ($@) { fail('end_element crashed: ' . $@); } else { ok(1, 'end_element did not crash'); }
is($mock_self->{curlist}, 'element1', 'curlist updated correctly after end_element');

# Test case 2: Edge case with empty lists
$mock_self->{lists} = [];
$mock_self->{curlist} = 'element1';

$result = eval { XML::Simple::end_element($mock_self) };
if ($@) { fail('end_element crashed with empty lists: ' . $@); } else { ok(1, 'end_element did not crash with empty lists'); }
is($mock_self->{curlist}, undef, 'curlist remains undef with empty lists');

# Test case 3: Edge case with deeply nested elements
$mock_self->{lists} = [['element1'], ['element2'], ['element3']];
$mock_self->{curlist} = 'element3';

$result = eval { XML::Simple::end_element($mock_self) };
if ($@) { fail('end_element crashed with deeply nested elements: ' . $@); } else { ok(1, 'end_element did not crash with deeply nested elements'); }
is($mock_self->{curlist}, 'element2', 'curlist updated correctly with deeply nested elements');

# Test case 4: Edge case with single element
$mock_self->{lists} = [['element1']];
$mock_self->{curlist} = 'element1';

$result = eval { XML::Simple::end_element($mock_self) };
if ($@) { fail('end_element crashed with single element: ' . $@); } else { ok(1, 'end_element did not crash with single element'); }
is($mock_self->{curlist}, undef, 'curlist is undef after single element');

done_testing();