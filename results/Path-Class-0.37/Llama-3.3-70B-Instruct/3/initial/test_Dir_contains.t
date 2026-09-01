use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::contains"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'contains is defined'); }

# Test case: Too many arguments
my $result = eval { Path::Class::Dir->new('/tmp')->contains('arg1', 'arg2', 'arg3') };
if ($@) { like($@, qr/Too many arguments given to contains\(\)/, 'Too many arguments'); } else { fail('Expected exception not thrown'); }

# Test case: No second entity
$result = eval { Path::Class::Dir->new('/tmp')->contains() };
if ($@) { like($@, qr/No second entity given to contains\(\)/, 'No second entity'); } else { fail('Expected exception not thrown'); }

# Test case: Directory does not exist
$result = eval { Path::Class::Dir->new('/non-existent-dir')->contains('/tmp') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result, 'Directory does not exist'); }

# Test case: Entity does not exist
$result = eval { Path::Class::Dir->new('/tmp')->contains('/non-existent-entity') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result, 'Entity does not exist'); }

# Test case: Directory contains entity
my $temp_dir = tempdir();
my $temp_file = File::Spec->catfile($temp_dir, 'temp_file');
open(my $fh, '>', $temp_file) or die $!;
close($fh);
$result = eval { Path::Class::Dir->new($temp_dir)->contains($temp_file) };
if ($@) { fail('Function crashed: ' . $@); } else { ok($result, 'Directory contains entity'); }
unlink($temp_file);
rmdir($temp_dir;

# Test case: Directory does not contain entity
$result = eval { Path::Class::Dir->new('/tmp')->contains('/non-existent-entity') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!$result, 'Directory does not contain entity'); }

done_testing();
