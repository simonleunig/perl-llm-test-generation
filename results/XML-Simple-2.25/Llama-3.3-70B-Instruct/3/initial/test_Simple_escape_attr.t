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

# Test case 1: Empty string
my $result = eval { XML::Simple->new->escape_attr('') };
if ($@) { fail('escape_attr crashed on empty string: ' . $@); } else { ok(defined $result, 'escape_attr returns result on empty string'); }

# Test case 2: String with only whitespace characters
$result = eval { XML::Simple->new->escape_attr('   ') };
if ($@) { fail('escape_attr crashed on whitespace string: ' . $@); } else { ok(defined $result, 'escape_attr returns result on whitespace string'); }

# Test case 3: String with special characters
$result = eval { XML::Simple->new->escape_attr('<foo> & "bar"') };
if ($@) { fail('escape_attr crashed on string with special characters: ' . $@); } else { ok(defined $result, 'escape_attr returns result on string with special characters'); }

# Test case 4: Non-scalar input
$result = eval { XML::Simple->new->escape_attr(123) };
if ($@) { fail('escape_attr did not crash on non-scalar input: ' . $@); } else { ok(!defined $result, 'escape_attr returns undefined on non-scalar input'); }

# Test case 5: Mocking escape_value function
my $mock = mock 'XML::Simple' => (
    escape_value => sub { '<mocked>' },
);
$result = eval { XML::Simple->new->escape_attr('foo') };
if ($@) { fail('escape_attr crashed with mocked escape_value: ' . $@); } else { is($result, '<mocked>', 'escape_attr uses mocked escape_value'); }

done_testing();
