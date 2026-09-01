use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::build_simple_tree"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'build_simple_tree is defined'); }

# Test case 1: Normal operation with keeproot option
my $simple = XML::Simple->new();
my $tree = eval { $simple->build_simple_tree('<root><foo>bar</foo></root>') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $tree, 'Function returns result with keeproot'); }

# Test case 2: Normal operation without keeproot option
$simple = XML::Simple->new(keeproot => 0);
$tree = eval { $simple->build_simple_tree('<root><foo>bar</foo></root>') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $tree, 'Function returns result without keeproot'); }

# Test case 3: Error handling with malformed XML
$simple = XML::Simple->new();
$tree = eval { $simple->build_simple_tree('<root><foo>bar</foo>') };
if ($@) { ok($@, 'Function crashes with malformed XML'); } else { fail('Function did not crash with malformed XML'); }

# Test case 4: Edge case with empty XML string
$simple = XML::Simple->new();
$tree = eval { $simple->build_simple_tree('') };
if ($@) { ok($@, 'Function crashes with empty XML string'); } else { fail('Function did not crash with empty XML string'); }

done_testing();
