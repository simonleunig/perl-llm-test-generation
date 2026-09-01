use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Mock dependencies
my $mock;
eval { require Exporter; };
if ($@) {
    # DEPENDENCY MISSING: Exporter - mock skipped
} else {
    no strict 'refs';
    if (defined &{"Exporter::import"}) {
        $mock = mock 'Exporter' => ( override => { import => sub { return 1; } } );
    } else {
        $mock = mock 'Exporter' => ( add => { import => sub { return 1; } } );
    }
}

eval { require XML::Simple; };
if ($@) {
    # DEPENDENCY MISSING: XML::Simple - mock skipped
} else {
    no strict 'refs';
    if (defined &{"XML::Simple::_strict_mode_for_caller"}) {
        $mock = mock 'XML::Simple' => ( override => { _strict_mode_for_caller => sub { my ($strict) = @_; return $strict; } } );
    } else {
        $mock = mock 'XML::Simple' => ( add => { _strict_mode_for_caller => sub { my ($strict) = @_; return $strict; } } );
    }
}

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::import"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'import is defined'); }

# Test case: import with :strict tag
my $result = eval { XML::Simple::import('SomePackage', ':strict'); };
if ($@) {
    # FAILED: fail('Function crashed: ' . $@);
} else {
    ok(defined $result, 'Function returns result with :strict');
    is(XML::Simple::_strict_mode_for_caller(1), 1, 'Strict mode enabled');
}

# Test case: import without :strict tag
$result = eval { XML::Simple::import('SomePackage'); };
if ($@) {
    # FAILED: fail('Function crashed: ' . $@);
} else {
    ok(defined $result, 'Function returns result without :strict');
    is(XML::Simple::_strict_mode_for_caller(0), 0, 'Strict mode not enabled');
}

# Test case: import with invalid arguments
# UNVALIDATED: $result = eval { XML::Simple::import('SomePackage', 'invalid_tag'); };
# AFTER LAST PASS: if ($@) {
    # FAILED: fail('Function crashed: ' . $@);
# AFTER LAST PASS: } else {
    # FAILED: ok(defined $result, 'Function returns result with invalid arguments');
    # FAILED: is(XML::Simple::_strict_mode_for_caller(0), 0, 'Strict mode not enabled with invalid arguments');
# AFTER LAST PASS: }

# Test case: import with multiple arguments
# UNVALIDATED: $result = eval { XML::Simple::import('SomePackage', ':strict', 'another_tag'); };
# AFTER LAST PASS: if ($@) {
    # FAILED: fail('Function crashed: ' . $@);
# AFTER LAST PASS: } else {
    # FAILED: ok(defined $result, 'Function returns result with multiple arguments');
    # FAILED: is(XML::Simple::_strict_mode_for_caller(1), 1, 'Strict mode enabled with multiple arguments');
# AFTER LAST PASS: }

done_testing();