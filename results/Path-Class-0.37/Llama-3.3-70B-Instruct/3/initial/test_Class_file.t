use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::file"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'file is defined'); }

# Test case 1: Successful creation of a Path::Class::File object
my $result = eval { Path::Class::file('test', 'file.txt') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }

# Test case 2: Invalid input (non-existent file)
$result = eval { Path::Class::file('non_existent', 'file.txt') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for non-existent file'); }

# Test case 3: Edge case - empty input
$result = eval { Path::Class::file() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for empty input'); }

# Test case 4: Mocking external dependency (Path::Class::File)
my $mock = mock 'Path::Class::File' => ( new => sub { bless {}, 'Path::Class::File' } );
$result = eval { Path::Class::file('test', 'file.txt') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result with mocked dependency'); }

done_testing();
