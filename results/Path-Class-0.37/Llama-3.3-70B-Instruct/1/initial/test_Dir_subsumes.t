use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::subsumes"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'subsumes is defined'); }

# Test case 1: Too many arguments
my $result = eval { Path::Class::Dir->new('/')->subsumes('/tmp', '/var', '/usr') };
if ($@) { like($@, qr/Too many arguments given to subsumes\(\)/, 'Too many arguments'); } else { fail('Expected exception not thrown'); }

# Test case 2: No second entity
$result = eval { Path::Class::Dir->new('/')->subsumes() };
if ($@) { like($@, qr/No second entity given to subsumes\(\)/, 'No second entity'); } else { fail('Expected exception not thrown'); }

# Test case 3: Second entity is not a Path::Class::Entity object
$result = eval { Path::Class::Dir->new('/')->subsumes('/tmp') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for non-Path::Class::Entity object'); }

# Test case 4: Second entity is not a directory
$result = eval { Path::Class::Dir->new('/')->subsumes('/tmp/file.txt') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for non-directory'); }

# Test case 5: Absolute paths
$result = eval { Path::Class::Dir->new('/')->subsumes('/tmp') };
if ($@) { fail('Function crashed: ' . $@); } else { ok($result, 'Absolute path subsumes'); }

# Test case 6: Relative paths
$result = eval { Path::Class::Dir->new('tmp')->subsumes('tmp') };
if ($@) { fail('Function crashed: ' . $@); } else { ok($result, 'Relative path subsumes'); }

# Test case 7: Volumes
$result = eval { Path::Class::Dir->new('/')->subsumes('/tmp', { volume => 'vol1' }) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!$result, 'Volumes do not match'); }

# Test case 8: Root directory subsumes everything
$result = eval { Path::Class::Dir->new('/')->subsumes('/') };
if ($@) { fail('Function crashed: ' . $@); } else { ok($result, 'Root directory subsumes'); }

# Test case 9: Current directory subsumes relative paths
$result = eval { Path::Class::Dir->new('.')->subsumes('./tmp') };
if ($@) { fail('Function crashed: ' . $@); } else { ok($result, 'Current directory subsumes relative path'); }

done_testing();
