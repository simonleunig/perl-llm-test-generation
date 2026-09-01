use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::XMLout"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'XMLout is defined'); }

my $data = { name => 'John', age => 30 };
my $result = eval { XML::Simple->new->XMLout($data) };
if ($@) { fail('XMLout crashed: ' . $@); } else { ok(defined $result, 'XMLout returns result for valid input'); }

my $invalid_data = 'not a reference';
$result = eval { XML::Simple->new->XMLout($invalid_data) };
if ($@) { like($@, qr/requires at least one argument/, 'XMLout crashes for invalid input'); } else { fail('XMLout did not crash for invalid input'); }

my $empty_data = {};
$result = eval { XML::Simple->new->XMLout($empty_data) };
if ($@) { fail('XMLout crashed: ' . $@); } else { ok(defined $result, 'XMLout returns result for empty input'); }

my $nested_data = { name => 'John', address => { street => '123 Main St', city => 'Anytown' } };
$result = eval { XML::Simple->new->XMLout($nested_data) };
if ($@) { fail('XMLout crashed: ' . $@); } else { ok(defined $result, 'XMLout returns result for nested input'); }

my $circular_data = { name => 'John' };
$circular_data->{self} = $circular_data;
$result = eval { XML::Simple->new->XMLout($circular_data) };
if ($@) { like($@, qr/Circular reference detected/, 'XMLout crashes for circular reference'); } else { fail('XMLout did not crash for circular reference'); }

my ($fh, $filename) = tempfile();
my $output_file_data = { name => 'John', age => 30 };
$result = eval { XML::Simple->new->XMLout($output_file_data, OutputFile => $filename) };
if ($@) { fail('XMLout crashed: ' . $@); } else { ok(defined $result, 'XMLout returns result for output file option'); }
unlink $filename;

my $handler_data = { name => 'John', age => 30 };
my $mock_handler;
eval { require XML::SAX; };
if ($@) {
    # DEPENDENCY MISSING: XML::SAX - mock skipped
} else {
    no strict 'refs';
    if (defined &{"XML::SAX::Handler::parse_string"}) {
        $mock_handler = mock 'XML::SAX::Handler' => ( override => [ parse_string => sub { return 'parsed string' } ] );
    } else {
        $mock_handler = mock 'XML::SAX::Handler' => ( add => [ parse_string => sub { return 'parsed string' } ] );
    }
}
$result = eval { XML::Simple->new->XMLout($handler_data, Handler => $mock_handler) };
if ($@) { fail('XMLout crashed: ' . $@); } else { ok(defined $result, 'XMLout returns result for handler option'); }

done_testing();