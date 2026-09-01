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

# Test case 1: Normal operation
my $simple = bless { lists => [ [ 'list1' ], [ 'list2' ] ], curlist => [ 'list2' ] }, 'XML::Simple';
my $result = eval { $simple->end_element() };
if ($@) { fail('end_element crashed: ' . $@); } else { ok(defined $simple->{curlist}, 'end_element updates curlist'); }

# Test case 2: Empty lists
$simple = bless { lists => [], curlist => undef }, 'XML::Simple';
$result = eval { $simple->end_element() };
if ($@) { fail('end_element crashed: ' . $@); } else { ok(!defined $simple->{curlist}, 'end_element handles empty lists'); }

# Test case 3: Undefined curlist
$simple = bless { lists => [ [ 'list1' ] ], curlist => undef }, 'XML::Simple';
$result = eval { $simple->end_element() };
if ($@) { fail('end_element crashed: ' . $@); } else { ok(defined $simple->{curlist}, 'end_element updates curlist'); }

done_testing();
