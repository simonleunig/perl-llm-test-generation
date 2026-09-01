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
if ($@) { fail('start_document crashed: ' . $@); } else { ok(defined $simple->{lists}, 'start_document sets lists'); }
is($simple->{lists}, [], 'lists is an empty arrayref');
is($simple->{curlist}, [], 'curlist is an empty arrayref');
is($simple->{tree}, [], 'tree is an empty arrayref');

$simple = bless { opt => 1 }, 'XML::Simple';
$result = eval { $simple->start_document() };
if ($@) { fail('start_document crashed: ' . $@); } else { ok(defined $simple->{lists}, 'start_document sets lists'); }
is($simple->{lists}, [], 'lists is an empty arrayref');
is($simple->{curlist}, [], 'curlist is an empty arrayref');
is($simple->{tree}, [], 'tree is an empty arrayref');

my $mock;
eval { require XML::Simple; };
if ($@) {
    # DEPENDENCY MISSING: XML::Simple - mock skipped
} else {
    no strict 'refs';
    if (defined &{"XML::Simple::handle_options"}) {
        $mock = mock 'XML::Simple' => ( override => [ handle_options => sub { } ] );
    } else {
        $mock = mock 'XML::Simple' => ( add => [ handle_options => sub { } ] );
    }
}

$simple = bless {}, 'XML::Simple';
$result = eval { $simple->start_document() };
if ($@) { fail('start_document crashed: ' . $@); } else { ok(defined $simple->{lists}, 'start_document sets lists'); }
is($simple->{lists}, [], 'lists is an empty arrayref');
is($simple->{curlist}, [], 'curlist is an empty arrayref');
is($simple->{tree}, [], 'tree is an empty arrayref');
if (defined $mock) {
    ok($mock->called('handle_options'), 'handle_options was called');
}

done_testing();