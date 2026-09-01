use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::import"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'import is defined'); }

my $result = eval { XML::Simple->import(':strict') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(1, 'import with :strict tag'); }

$result = eval { XML::Simple->import() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(1, 'import without :strict tag'); }

$result = eval { XML::Simple->import(':other') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(1, 'import with other symbols'); }

$result = eval { XML::Simple->import(':strict', ':other') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(1, 'import with multiple symbols'); }

done_testing();