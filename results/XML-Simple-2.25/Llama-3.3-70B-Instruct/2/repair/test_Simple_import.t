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
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'import with :strict returns result'); }

$result = eval { XML::Simple->import() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'import without :strict returns result'); }

$result = eval { XML::Simple->import(':strict', 'other_arg') };
if ($@) { 
    like($@, qr/"other_arg" is not exported by the XML::Simple module/, 'import with other arguments throws correct error');
} else { 
    ok(defined $result, 'import with other arguments returns result'); 
}

$result = eval { XML::Simple->import('invalid_arg') };
if ($@) { 
    like($@, qr/"invalid_arg" is not exported by the XML::Simple module/, 'import with invalid arguments throws correct error');
} else { 
    ok(defined $result, 'import with invalid arguments returns result'); 
}

done_testing();