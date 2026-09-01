use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }  # Use actual module name from package declaration

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::storable_filename"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'storable_filename is defined'); }

# Test cases with eval protection

# Normal case: filename with .xml suffix
my $result = eval { XML::Simple::storable_filename(undef, 'data.xml') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'data.stor', 'Filename with .xml suffix is converted correctly'); }

# Normal case: filename without .xml suffix
$result = eval { XML::Simple::storable_filename(undef, 'data') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'data.stor', 'Filename without .xml suffix is converted correctly'); }

# Edge case: empty filename
$result = eval { XML::Simple::storable_filename(undef, '') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, '.stor', 'Empty filename is handled correctly'); }

# Edge case: undefined filename
$result = eval { XML::Simple::storable_filename(undef, undef) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, '.stor', 'Undefined filename is handled correctly'); }

# Edge case: filename with multiple dots
$result = eval { XML::Simple::storable_filename(undef, 'data.tar.xml') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'data.tar.stor', 'Filename with multiple dots is handled correctly'); }

# Edge case: filename with no extension
$result = eval { XML::Simple::storable_filename(undef, 'data') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'data.stor', 'Filename with no extension is handled correctly'); }

# Edge case: filename with multiple .xml extensions
$result = eval { XML::Simple::storable_filename(undef, 'data.xml.xml') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'data.xml.stor', 'Filename with multiple .xml extensions is handled correctly'); }

# Edge case: filename with special characters
$result = eval { XML::Simple::storable_filename(undef, 'data@#$%^&*.xml') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'data@#$%^&*.stor', 'Filename with special characters is handled correctly'); }

done_testing();
