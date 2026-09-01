use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::start_document"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'start_document is defined'); }

# Test case 1: Test start_document with an object that has opt defined
my $obj1 = bless {}, 'XML::Simple';
$obj1->{opt} = {};
my $result1 = eval { $obj1->start_document() };
if ($@) { fail('start_document crashed: ' . $@); } else { ok(defined $result1, 'start_document returns result when opt is defined'); }
is($obj1->{lists}, [], 'lists is initialized correctly when opt is defined');
is($obj1->{curlist}, [], 'curlist is initialized correctly when opt is defined');
is($obj1->{tree}, [], 'tree is initialized correctly when opt is defined');

# Test case 2: Test start_document with an object that does not have opt defined
my $obj2 = bless {}, 'XML::Simple';
my $mock_handle_options = mock 'XML::Simple' => (track => 1);
$mock_handle_options->add('handle_options', sub { $obj2->{opt} = {} });
my $result2 = eval { $obj2->start_document() };
if ($@) { fail('start_document crashed: ' . $@); } else { ok(defined $result2, 'start_document returns result when opt is not defined'); }
is($obj2->{lists}, [], 'lists is initialized correctly when opt is not defined');
is($obj2->{curlist}, [], 'curlist is initialized correctly when opt is not defined');
is($obj2->{tree}, [], 'tree is initialized correctly when opt is not defined');
is($mock_handle_options->called('handle_options'), 1, 'handle_options is called when opt is not defined');

done_testing();