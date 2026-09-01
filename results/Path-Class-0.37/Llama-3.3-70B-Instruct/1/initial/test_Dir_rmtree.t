use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::rmtree"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'rmtree is defined'); }

# Test case: Remove a directory that exists
my $temp_dir = tempdir(CLEANUP => 1);
my $dir = Path::Class::Dir->new($temp_dir);
my $result = eval { $dir->rmtree() };
if ($@) { fail('rmtree crashed: ' . $@); } else { ok(! -e $temp_dir, 'Directory removed successfully'); }

# Test case: Remove a directory that does not exist
my $non_existent_dir = Path::Class::Dir->new('non_existent_dir');
$result = eval { $non_existent_dir->rmtree() };
if ($@) { fail('rmtree crashed: ' . $@); } else { ok(1, 'rmtree on non-existent directory did not crash'); }

# Test case: Remove a directory with read-only permissions
my $read_only_dir = tempdir(CLEANUP => 1);
chmod 0444, $read_only_dir;
my $read_only_dir_obj = Path::Class::Dir->new($read_only_dir);
$result = eval { $read_only_dir_obj->rmtree() };
if ($@) { fail('rmtree crashed: ' . $@); } else { ok(! -e $read_only_dir, 'Read-only directory removed successfully'); }

# Test case: Mock File::Path::rmtree to test error handling
my $mock = mock 'File::Path' => ( rmtree => sub { die 'Mocked error' } );
my $dir_obj = Path::Class::Dir->new($temp_dir);
$result = eval { $dir_obj->rmtree() };
if ($@) { ok($@ =~ /Mocked error/, 'Error handling works correctly'); } else { fail('Error handling failed'); }

done_testing();
