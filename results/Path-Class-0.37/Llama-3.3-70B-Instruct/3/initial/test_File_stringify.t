use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::stringify"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'stringify is defined'); }

# Test case 1: File object with no directory component
my $file_obj1 = bless { file => 'test_file.txt' }, 'Path::Class::File';
my $result1 = eval { Path::Class::File::stringify($file_obj1) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result1, 'test_file.txt', 'File name only returned when no directory'); }

# Test case 2: File object with directory component
my $dir_obj = bless { dir => 'test_dir' }, 'Path::Class::Dir';
my $file_obj2 = bless { dir => $dir_obj, file => 'test_file.txt' }, 'Path::Class::File';
my $mock_catfile = mock 'Path::Class::File' => ( catfile => sub { join '/', $_[1]->{dir}, $_[2] } );
my $result2 = eval { Path::Class::File::stringify($file_obj2) };
if ($@) { fail('Function crashed: ' . $@); } else { is($result2, 'test_dir/test_file.txt', 'Directory and file name concatenated correctly'); }

# Test case 3: Invalid input (non-Path::Class::File object)
my $invalid_obj = bless {}, 'InvalidClass';
my $result3 = eval { Path::Class::File::stringify($invalid_obj) };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result3, 'Invalid input returns undefined'); }

done_testing();
