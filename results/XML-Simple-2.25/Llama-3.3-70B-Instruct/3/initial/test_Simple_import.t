use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::import"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'import is defined'); }

# Test case 1: import with :strict
my $result = eval { XML::Simple->import(':strict') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'import with :strict returns result'); }

# Test case 2: import without :strict
$result = eval { XML::Simple->import() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'import without :strict returns result'); }

# Test case 3: import with other symbols
$result = eval { XML::Simple->import('other_symbol') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'import with other symbols returns result'); }

# Test case 4: import with multiple symbols
$result = eval { XML::Simple->import(':strict', 'other_symbol') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'import with multiple symbols returns result'); }

done_testing();
