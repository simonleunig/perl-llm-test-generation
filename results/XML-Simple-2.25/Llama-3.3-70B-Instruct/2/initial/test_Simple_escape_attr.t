use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::escape_attr"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'escape_attr is defined'); }

# Test cases with eval protection
my $object = bless {}, 'XML::Simple';
my $result = eval { $object->escape_attr('test') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }

# Test escaping of special characters
$result = eval { $object->escape_attr('<test>') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, '&lt;test&gt;', 'Special characters are escaped'); }

# Test non-special characters
$result = eval { $object->escape_attr('test') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'test', 'Non-special characters are not modified'); }

# Test attribute value with &
$result = eval { $object->escape_attr('test & test') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'test &amp; test', 'Ampersand is escaped'); }

# Test attribute value with "
$result = eval { $object->escape_attr('test " test') };
if ($@) { fail('Function crashed: ' . $@); } else { is($result, 'test &quot; test', 'Double quote is escaped'); }

done_testing();
