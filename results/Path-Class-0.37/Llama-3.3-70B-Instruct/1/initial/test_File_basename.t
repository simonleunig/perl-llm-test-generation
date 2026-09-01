use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::basename"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'basename is defined'); }

# Test case: Create a Path::Class::File object and call basename
my $file = Path::Class::File->new('path/to/file.txt');
my $result = eval { $file->basename() };
if ($@) { fail('basename crashed: ' . $@); } else { is($result, 'file.txt', 'basename returns file name'); }

# Test case: Edge case - empty file name
my $empty_file = Path::Class::File->new('path/to/');
my $empty_result = eval { $empty_file->basename() };
if ($@) { fail('basename crashed on empty file name: ' . $@); } else { is($empty_result, '', 'basename returns empty string on empty file name'); }

# Test case: Edge case - file name with special characters
my $special_file = Path::Class::File->new('path/to/file_with_special_chars!@#$%^&*().txt');
my $special_result = eval { $special_file->basename() };
if ($@) { fail('basename crashed on file name with special characters: ' . $@); } else { is($special_result, 'file_with_special_chars!@#$%^&*().txt', 'basename returns file name with special characters'); }

done_testing();
