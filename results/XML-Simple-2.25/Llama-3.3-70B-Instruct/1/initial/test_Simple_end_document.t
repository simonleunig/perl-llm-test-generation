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

# Test case 1: nocollapse option set
my $simple = bless({}, 'XML::Simple');
$simple->{tree} = ['root', { foo => 'bar' }];
$simple->{nocollapse} = 1;
my $result = eval { $simple->end_document() };
if ($@) { fail('end_document crashed with nocollapse: ' . $@); } else { ok(defined $result, 'end_document returns result with nocollapse'); }

# Test case 2: keeproot option set
$simple = bless({}, 'XML::Simple');
$simple->{tree} = ['root', { foo => 'bar' }];
$simple->{opt} = { keeproot => 1 };
$result = eval { $simple->end_document() };
if ($@) { fail('end_document crashed with keeproot: ' . $@); } else { ok(defined $result, 'end_document returns result with keeproot'); }

# Test case 3: datahandler option set
$simple = bless({}, 'XML::Simple');
$simple->{tree} = ['root', { foo => 'bar' }];
$simple->{opt} = { datahandler => sub { return 'handled data'; } };
$result = eval { $simple->end_document() };
if ($@) { fail('end_document crashed with datahandler: ' . $@); } else { ok(defined $result, 'end_document returns result with datahandler'); }

# Test case 4: collapse without options
$simple = bless({}, 'XML::Simple');
$simple->{tree} = ['root', { foo => 'bar' }];
$result = eval { $simple->end_document() };
if ($@) { fail('end_document crashed without options: ' . $@); } else { ok(defined $result, 'end_document returns result without options'); }

done_testing();
