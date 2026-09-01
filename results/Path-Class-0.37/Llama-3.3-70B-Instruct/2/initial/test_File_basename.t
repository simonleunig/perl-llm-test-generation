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

# Test cases with eval protection
my $file = Path::Class::File->new('test.txt');
my $result = eval { $file->basename() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }
is($result, 'test.txt', 'basename returns the correct file name');

# Test with directory
my $file_with_dir = Path::Class::File->new('/path/to/test.txt');
my $result_with_dir = eval { $file_with_dir->basename() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result_with_dir, 'Function returns result with directory'); }
is($result_with_dir, 'test.txt', 'basename returns the correct file name with directory');

# Test with empty file name
my $empty_file = Path::Class::File->new('');
my $result_empty = eval { $empty_file->basename() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result_empty, 'Function returns result with empty file name'); }
is($result_empty, '', 'basename returns an empty string with empty file name');

done_testing();
