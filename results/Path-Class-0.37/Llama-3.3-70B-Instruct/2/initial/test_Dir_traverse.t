use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::traverse"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'traverse is defined'); }

# Test case 1: Successful traversal
my $dir = Path::Class::Dir->new(tempdir());
my $result = eval { $dir->traverse(sub { 1 }, 'arg1', 'arg2') };
if ($@) { fail('Traverse crashed: ' . $@); } else { ok(defined $result, 'Traverse returns result'); }

# Test case 2: Empty directory
my $empty_dir = Path::Class::Dir->new(tempdir());
my $empty_result = eval { $empty_dir->traverse(sub { 1 }, 'arg1', 'arg2') };
if ($@) { fail('Empty traverse crashed: ' . $@); } else { ok(defined $empty_result, 'Empty traverse returns result'); }

# Test case 3: Non-existent directory
my $non_existent_dir = Path::Class::Dir->new('non_existent_dir');
my $non_existent_result = eval { $non_existent_dir->traverse(sub { 1 }, 'arg1', 'arg2') };
if ($@) { ok($@, 'Non-existent directory raises error'); } else { fail('Non-existent directory did not raise error'); }

# Test case 4: Callback function throws error
my $error_dir = Path::Class::Dir->new(tempdir());
my $error_result = eval { $error_dir->traverse(sub { die 'Callback error' }, 'arg1', 'arg2') };
if ($@) { ok($@, 'Callback error raises error'); } else { fail('Callback error did not raise error'); }

done_testing();
