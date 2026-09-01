use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::escape_attr"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'escape_attr is defined'); }

my $result = eval { XML::Simple->new->escape_attr('') };
if ($@) { fail('escape_attr crashed on empty string: ' . $@); } else { ok(defined $result, 'escape_attr returns result on empty string'); }

$result = eval { XML::Simple->new->escape_attr('   ') };
if ($@) { fail('escape_attr crashed on whitespace string: ' . $@); } else { ok(defined $result, 'escape_attr returns result on whitespace string'); }

$result = eval { XML::Simple->new->escape_attr('<foo> & "bar"') };
if ($@) { fail('escape_attr crashed on string with special characters: ' . $@); } else { ok(defined $result, 'escape_attr returns result on string with special characters'); }

$result = eval { XML::Simple->new->escape_attr(123) };
if ($@) { fail('escape_attr crashed on non-scalar input: ' . $@); } else { ok(!defined $result, 'escape_attr returns undefined on non-scalar input'); }

my $mock;
eval { require XML::Simple; };
if ($@) {
    # DEPENDENCY MISSING: XML::Simple - mock skipped  
} else {
    no strict 'refs';
    if (defined &{"XML::Simple::escape_value"}) {
        $mock = mock 'XML::Simple' => ( override => [ escape_value => sub { '<mocked>' } ] );
    } else {
        $mock = mock 'XML::Simple' => ( add => [ escape_value => sub { '<mocked>' } ] );
    }
}

$result = eval { XML::Simple->new->escape_attr('foo') };
if ($@) { fail('escape_attr crashed with mocked escape_value: ' . $@); } else { is($result, '<mocked>', 'escape_attr uses mocked escape_value'); }

done_testing();