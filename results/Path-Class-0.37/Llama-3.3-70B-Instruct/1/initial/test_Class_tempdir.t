use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock;
use File::Temp;
use File::Spec;
use lib '.';
BEGIN { require Path::Class; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::tempdir"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'tempdir is defined'); }

# Test case: Successful creation of a temporary directory
my $result = eval { Path::Class::tempdir() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }

# Test case: Check if the returned object is an instance of Path::Class::Dir
$result = eval { Path::Class::tempdir() };
if ($@) { fail('Function crashed: ' . $@); } else { ok($result->isa('Path::Class::Dir'), 'Returned object is an instance of Path::Class::Dir'); }

# Test case: Check if the temporary directory exists
$result = eval { Path::Class::tempdir() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(-d $result->stringify, 'Temporary directory exists'); }

# Test case: Error handling - mock File::Temp::tempdir to return undef
my $mock = mock 'File::Temp' => (tempdir => sub { return undef });
$result = eval { Path::Class::tempdir() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result, 'Function returns undef when File::Temp::tempdir fails'); }

done_testing();
