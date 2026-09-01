use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::storable_filename"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'storable_filename is defined'); }

my $result = eval { XML::Simple->storable_filename('') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, '.stor', 'Empty filename returns .stor'); }

$result = eval { XML::Simple->storable_filename('test') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'test.stor', 'Filename without extension returns .stor'); }

$result = eval { XML::Simple->storable_filename('test.xml') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'test.stor', 'Filename with .xml extension returns .stor'); }

$result = eval { XML::Simple->storable_filename('test.stor') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'test.stor', 'Filename with .stor extension returns .stor'); }

$result = eval { XML::Simple->storable_filename(undef) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, '.stor', 'Undefined filename returns .stor'); }

done_testing();