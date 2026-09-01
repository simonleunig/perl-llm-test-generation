use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require XML::Simple; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"XML::Simple::XMLout"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'XMLout is defined'); }

# Test case 1: Valid input data structure
my $data = { name => 'John', age => 30 };
my $result = eval { XML::Simple->new()->XMLout($data) };
if ($@) { fail('XMLout crashed: ' . $@); } else { ok(defined $result, 'XMLout returns result for valid input'); }

# Test case 2: Invalid input data structure
my $invalid_data = 'not a reference';
$result = eval { XML::Simple->new()->XMLout($invalid_data) };
if ($@) { like($@, qr/requires at least one argument/, 'XMLout crashes for invalid input'); } else { fail('XMLout did not crash for invalid input'); }

# Test case 3: Empty input data structure
my $empty_data = {};
$result = eval { XML::Simple->new()->XMLout($empty_data) };
if ($@) { fail('XMLout crashed: ' . $@); } else { ok(defined $result, 'XMLout returns result for empty input'); }

# Test case 4: Nested input data structure
my $nested_data = { name => 'John', address => { street => '123 Main St', city => 'Anytown' } };
$result = eval { XML::Simple->new()->XMLout($nested_data) };
if ($@) { fail('XMLout crashed: ' . $@); } else { ok(defined $result, 'XMLout returns result for nested input'); }

# Test case 5: Input data structure with circular reference
my $circular_data = { name => 'John' };
$circular_data->{self} = $circular_data;
$result = eval { XML::Simple->new()->XMLout($circular_data) };
if ($@) { like($@, qr/Circular reference detected/, 'XMLout crashes for circular reference'); } else { fail('XMLout did not crash for circular reference'); }

# Test case 6: Output file option
my ($fh, $filename) = tempfile();
my $output_file = $filename;
$result = eval { XML::Simple->new()->XMLout($data, OutputFile => $output_file) };
if ($@) { fail('XMLout crashed: ' . $@); } else { ok(defined $result, 'XMLout returns result for output file option'); }
unlink $output_file;

# Test case 7: Handler option
my $handler = mock('XML::SAX::Handler' => ( 'start_document' => sub { }, 'end_document' => sub { }, 'start_element' => sub { }, 'end_element' => sub { }, 'characters' => sub { } ));
$result = eval { XML::Simple->new()->XMLout($data, Handler => $handler) };
if ($@) { fail('XMLout crashed: ' . $@); } else { ok(defined $result, 'XMLout returns result for handler option'); }

done_testing();
