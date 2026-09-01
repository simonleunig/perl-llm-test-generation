use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock;
use File::Temp;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::basename"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'basename is defined'); }

# Test case: Normal file object
my $file = Path::Class::File->new('file.txt');
my $result = eval { $file->basename() };
if ($@) { fail('basename crashed: ' . $@); } else { is($result, 'file.txt', 'basename returns file name'); }

# Test case: File object with directory
my $file_with_dir = Path::Class::File->new('/path/to/file.txt');
my $result_with_dir = eval { $file_with_dir->basename() };
if ($@) { fail('basename crashed: ' . $@); } else { is($result_with_dir, 'file.txt', 'basename returns file name with directory'); }

# Test case: File object with no file
my $file_no_file = bless { dir => '/path/to' }, 'Path::Class::File';
my $result_no_file = eval { $file_no_file->basename() };
if ($@) { fail('basename crashed: ' . $@); } else { is($result_no_file, undef, 'basename returns undef for no file'); }

done_testing();
