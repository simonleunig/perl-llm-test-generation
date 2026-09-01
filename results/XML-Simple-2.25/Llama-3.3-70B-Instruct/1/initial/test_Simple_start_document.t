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

# Test case 1: Test start_document with default options
my $simple = bless {}, 'XML::Simple';
my $result = eval { $simple->start_document() };
if ($@) { fail('start_document crashed: ' . $@); } else { ok(defined $simple->{lists}, 'start_document sets lists'); }
is($simple->{lists}, [], 'lists is an empty arrayref');
is($simple->{curlist}, [], 'curlist is an empty arrayref');
is($simple->{tree}, [], 'tree is an empty arrayref');

# Test case 2: Test start_document with handle_options
$simple = bless { opt => 1 }, 'XML::Simple';
$result = eval { $simple->start_document() };
if ($@) { fail('start_document crashed: ' . $@); } else { ok(defined $simple->{lists}, 'start_document sets lists'); }
is($simple->{lists}, [], 'lists is an empty arrayref');
is($simple->{curlist}, [], 'curlist is an empty arrayref');
is($simple->{tree}, [], 'tree is an empty arrayref');

# Test case 3: Test start_document with mock handle_options
$simple = bless {}, 'XML::Simple';
my $mock = mock 'XML::Simple' => ( track => 1 );
$mock->add_mock('handle_options', sub { });
$result = eval { $simple->start_document() };
if ($@) { fail('start_document crashed: ' . $@); } else { ok(defined $simple->{lists}, 'start_document sets lists'); }
is($simple->{lists}, [], 'lists is an empty arrayref');
is($simple->{curlist}, [], 'curlist is an empty arrayref');
is($simple->{tree}, [], 'tree is an empty arrayref');
ok($mock->called('handle_options'), 'handle_options was called');

done_testing();
