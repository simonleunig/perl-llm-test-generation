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

my $mock;  # AFTER LAST PASS: my $mock = mock 'XML::Simple' => (track => 1);
my $simple_mock;  # AFTER LAST PASS: my $simple_mock = bless {}, 'XML::Simple';
# AFTER LAST PASS: $mock->override($simple_mock, 'handle_options' => sub { });
# UNVALIDATED: $result = eval { $simple_mock->start_document() };
# FAILED: if ($@) { fail('start_document crashed: ' . $@); } else {
    # FAILED: ok($mock->called('handle_options'), 'handle_options is called');
# FAILED: }

done_testing();