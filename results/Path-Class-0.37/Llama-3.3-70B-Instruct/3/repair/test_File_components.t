use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::components"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'components is defined'); }

# Test case: components with no arguments
my $file = Path::Class::File->new('path/to/file.txt');
my $result = eval { $file->components() };
if ($@) { fail('components crashed: ' . $@); } else { ok(defined $result, 'components returns result'); }

# Test case: components with arguments (should throw an exception)
my $file_with_args = Path::Class::File->new('path/to/file.txt');
my $result_with_args = eval { $file_with_args->components('arg1', 'arg2') };
if ($@) { ok($@, 'components throws exception with arguments'); } else { fail('components did not throw exception with arguments'); }

# Test case: components with a file that has no directory components
my $file_no_dir = Path::Class::File->new('file.txt');
my $result_no_dir = eval { $file_no_dir->components() };
if ($@) { fail('components crashed: ' . $@); } else { ok(defined $result_no_dir, 'components returns result for file with no directory components'); }

# Test case: components with a file that has directory components
my $file_with_dir = Path::Class::File->new('path/to/file.txt');
my $result_with_dir = eval { $file_with_dir->components() };
if ($@) { fail('components crashed: ' . $@); } else { ok(defined $result_with_dir, 'components returns result for file with directory components'); }

done_testing();
