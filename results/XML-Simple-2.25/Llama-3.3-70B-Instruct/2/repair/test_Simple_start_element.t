use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::start_element"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'start_element is defined'); }

my $simple = bless({}, 'XML::Simple');
$simple->{opt} = { nsexpand => 0 };
my $element = { Name => 'test', Attributes => { attr1 => { Name => 'attr1', Value => 'value1' } } };
my $result = eval { XML::Simple::start_element($simple, $element) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }

$simple = bless({}, 'XML::Simple');
$simple->{opt} = { nsexpand => 1 };
$element = { Name => 'test', LocalName => 'local', NamespaceURI => 'http://example.com', Attributes => { attr1 => { Name => 'attr1', LocalName => 'local_attr1', NamespaceURI => 'http://example.com', Value => 'value1' } } };
$result = eval { XML::Simple::start_element($simple, $element) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }

$simple = bless({}, 'XML::Simple');
$simple->{opt} = { nsexpand => 0 };
$element = { Name => 'test' };
$result = eval { XML::Simple::start_element($simple, $element) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }

$simple = bless({}, 'XML::Simple');
$simple->{opt} = { nsexpand => 0 };
$element = undef;
my $error = eval { XML::Simple::start_element($simple, $element) };
if ($@) { ok(1, 'Function dies with undefined input'); like($@, qr/Can't use an undefined value as a HASH reference/, 'Error message correct'); } else { fail('Function did not die as expected'); }

done_testing();