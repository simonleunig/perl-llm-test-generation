use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::start_element"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'start_element is defined'); }

# Test case 1: Normal operation with nsexpand option disabled
my $simple = bless({}, 'XML::Simple');
$simple->{opt} = { nsexpand => 0 };
my $element = { Name => 'test', Attributes => { attr1 => { Name => 'attr1', Value => 'value1' } } };
my $result = eval { $simple->start_element($element) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }

# Test case 2: Normal operation with nsexpand option enabled
$simple = bless({}, 'XML::Simple');
$simple->{opt} = { nsexpand => 1 };
$element = { Name => 'test', LocalName => 'local', NamespaceURI => 'http://example.com', Attributes => { attr1 => { Name => 'attr1', LocalName => 'local_attr1', NamespaceURI => 'http://example.com', Value => 'value1' } } };
$result = eval { $simple->start_element($element) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }

# Test case 3: Edge case with undefined Attributes
$simple = bless({}, 'XML::Simple');
$simple->{opt} = { nsexpand => 0 };
$element = { Name => 'test' };
$result = eval { $simple->start_element($element) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }

# Test case 4: Error handling with invalid input
$simple = bless({}, 'XML::Simple');
$simple->{opt} = { nsexpand => 0 };
$element = undef;
$result = eval { $simple->start_element($element) };
if ($@) { ok(1, 'Function crashed as expected'); } else { fail('Function did not crash as expected'); }

done_testing();
