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

# Test case: import with :strict tag
my $result = eval { XML::Simple->import(':strict') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'import with :strict returns result'); }

# Test case: import without :strict tag
$result = eval { XML::Simple->import() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'import without :strict returns result'); }

# Test case: import with other arguments
$result = eval { XML::Simple->import(':strict', 'other_arg') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'import with other arguments returns result'); }

# Test case: import with invalid arguments
$result = eval { XML::Simple->import('invalid_arg') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'import with invalid arguments returns result'); }

done_testing();
