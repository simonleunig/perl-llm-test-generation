use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::end_document"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'end_document is defined'); }

# Test case 1: Test end_document with nocollapse option
my $simple = bless({}, 'XML::Simple');
$simple->{tree} = [];
$simple->{nocollapse} = 1;
my $result = eval { $simple->end_document() };
if ($@) { fail('end_document crashed: ' . $@); } else { ok(defined $result, 'end_document returns result with nocollapse'); }

# Test case 2: Test end_document without nocollapse option
$simple = bless({}, 'XML::Simple');
$simple->{tree} = [];
$simple->{nocollapse} = 0;
$simple->{opt} = {};
$result = eval { $simple->end_document() };
if ($@) { fail('end_document crashed: ' . $@); } else { ok(defined $result, 'end_document returns result without nocollapse'); }

# Test case 3: Test end_document with keeproot option
$simple = bless({}, 'XML::Simple');
$simple->{tree} = [];
$simple->{nocollapse} = 0;
$simple->{opt} = { keeproot => 1 };
$result = eval { $simple->end_document() };
if ($@) { fail('end_document crashed: ' . $@); } else { ok(defined $result, 'end_document returns result with keeproot'); }

# Test case 4: Test end_document with datahandler option
$simple = bless({}, 'XML::Simple');
$simple->{tree} = [];
$simple->{nocollapse} = 0;
$simple->{opt} = { datahandler => sub { return 'handled data'; } };
$result = eval { $simple->end_document() };
if ($@) { fail('end_document crashed: ' . $@); } else { ok(defined $result, 'end_document returns result with datahandler'); }

done_testing();
