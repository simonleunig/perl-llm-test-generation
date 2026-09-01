use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::storable_filename"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'storable_filename is defined'); }

# Test case 1: Input filename with .xml extension
my $result1 = eval { XML::Simple->storable_filename('example.xml') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result1, 'example.xml.stor', 'storable_filename with .xml extension'); }

# Test case 2: Input filename without .xml extension
my $result2 = eval { XML::Simple->storable_filename('example') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result2, 'example.stor', 'storable_filename without .xml extension'); }

# Test case 3: Input filename is undef
my $result3 = eval { XML::Simple->storable_filename(undef) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result3, undef, 'storable_filename with undef input'); }

done_testing();
