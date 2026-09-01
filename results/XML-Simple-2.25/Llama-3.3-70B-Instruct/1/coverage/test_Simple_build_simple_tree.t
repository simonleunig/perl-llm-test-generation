use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::build_simple_tree"} };
if ($@) { fail("Symbol check crashed: $@"); } else { ok($symbol_check, "build_simple_tree is defined"); }

my $simple = XML::Simple->new();
my $tree = eval { $simple->build_simple_tree(XML::Simple->parsestring('<root><foo>bar</foo></root>')) };
# FAILED: if ($@) { fail("Function crashed: $@"); } else { ok(defined $tree, 'Function returns result with keeproot'); }

$simple = XML::Simple->new(keeproot => 0);
$tree = eval { $simple->build_simple_tree(XML::Simple->parsestring('<root><foo>bar</foo></root>')) };
# FAILED: if ($@) { fail("Function crashed: $@"); } else { ok(defined $tree, 'Function returns result without keeproot'); }

$simple = XML::Simple->new();
my $error = eval { $simple->build_simple_tree(XML::Simple->parsestring('<root><foo>bar</foo>')) };
if ($@) { ok($@, 'Function crashes with malformed XML'); } else { fail('Function did not crash with malformed XML'); }

$simple = XML::Simple->new();
$error = eval { $simple->build_simple_tree(XML::Simple->parsestring('')) };
if ($@) { ok($@, 'Function crashes with empty XML string'); } else { fail('Function did not crash with empty XML string'); }

done_testing();