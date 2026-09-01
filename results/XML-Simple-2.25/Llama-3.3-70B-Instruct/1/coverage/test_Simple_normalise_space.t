use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::normalise_space"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'normalise_space is defined'); }

# Test case 1: Empty string
my $result = eval { XML::Simple->normalise_space('') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, '', 'Empty string returns empty string'); }

# Test case 2: String with only whitespace characters
$result = eval { XML::Simple->normalise_space('   ') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, '', 'String with only whitespace characters returns empty string'); }

# Test case 3: String with leading and trailing whitespace characters
$result = eval { XML::Simple->normalise_space('   Hello World   ') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'Hello World', 'String with leading and trailing whitespace characters is normalized correctly'); }

# Test case 4: String with multiple consecutive whitespace characters
$result = eval { XML::Simple->normalise_space('Hello  World') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'Hello World', 'String with multiple consecutive whitespace characters is normalized correctly'); }

# Test case 5: String without any whitespace characters
$result = eval { XML::Simple->normalise_space('HelloWorld') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'HelloWorld', 'String without any whitespace characters is not modified'); }

done_testing();
