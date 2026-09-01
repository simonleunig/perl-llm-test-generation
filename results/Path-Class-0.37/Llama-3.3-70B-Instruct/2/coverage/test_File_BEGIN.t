use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

# Function existence check for the dir method, which parent is aliased to
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::dir"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'dir method is defined'); }

# Test that parent is correctly aliased to dir
my $parent_aliased = eval { no strict 'refs'; \&{"Path::Class::File::parent"} == \&{"Path::Class::File::dir"} };
if ($@) { fail('Alias check crashed: ' . $@); } else { ok($parent_aliased, 'parent is aliased to dir'); }

# Test creating a new Path::Class::File object
my $file = eval { Path::Class::File->new('test.txt') };
if ($@) { fail('Creating Path::Class::File object failed: ' . $@); } else { ok(defined $file, 'Created Path::Class::File object'); }

# Test the dir method (via the parent alias) on the file object
my $dir = eval { $file->parent };
if ($@) { fail('Calling parent (dir) on file object failed: ' . $@); } else { ok(defined $dir, 'Got directory from file object'); }

# More test cases can be added here for comprehensive coverage

done_testing();
