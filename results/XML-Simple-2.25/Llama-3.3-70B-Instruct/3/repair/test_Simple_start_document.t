use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::start_document"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'start_document is defined'); }

my $simple = bless {}, 'XML::Simple';
my $result = eval { $simple->start_document() };
if ($@) { fail('start_document crashed: ' . $@); } else { ok(defined $result, 'start_document returns result'); }

$result = eval { $simple->start_document() };
if ($@) { fail('start_document crashed: ' . $@); } else {
    ok(defined $simple->{lists}, 'lists is defined');
    ok(defined $simple->{curlist}, 'curlist is defined');
    ok(defined $simple->{tree}, 'tree is defined');
}

my $mock = mock 'XML::Simple' => (track => 1);
my $simple_mock = bless {}, 'XML::Simple';
$mock->override($simple_mock, 'handle_options' => sub { });
$result = eval { $simple_mock->start_document() };
if ($@) { fail('start_document crashed: ' . $@); } else {
    ok($mock->called('handle_options'), 'handle_options is called');
}

done_testing();