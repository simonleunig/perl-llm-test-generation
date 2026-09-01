use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::dir_list"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'dir_list is defined'); }

# Test case 1: dir_list with no arguments
my $dir = Path::Class::Dir->new('path/to/directory');
my $result = eval { $dir->dir_list() };
if ($@) { fail('dir_list crashed: ' . $@); } else { ok(defined $result, 'dir_list returns result'); }

# Test case 2: dir_list with offset
$result = eval { $dir->dir_list(1) };
if ($@) { fail('dir_list crashed: ' . $@); } else { ok(defined $result, 'dir_list with offset returns result'); }

# Test case 3: dir_list with offset and length
$result = eval { $dir->dir_list(1, 2) };
if ($@) { fail('dir_list crashed: ' . $@); } else { ok(defined $result, 'dir_list with offset and length returns result'); }

# Test case 4: dir_list with negative offset
$result = eval { $dir->dir_list(-1) };
if ($@) { fail('dir_list crashed: ' . $@); } else { ok(defined $result, 'dir_list with negative offset returns result'); }

# Test case 5: dir_list with negative length
$result = eval { $dir->dir_list(1, -2) };
if ($@) { fail('dir_list crashed: ' . $@); } else { ok(defined $result, 'dir_list with negative length returns result'); }

# Test case 6: dir_list in scalar context
my $scalar_result = eval { scalar $dir->dir_list(1) };
if ($@) { fail('dir_list crashed: ' . $@); } else { ok(defined $scalar_result, 'dir_list in scalar context returns result'); }

done_testing();
