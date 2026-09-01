use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::next"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'next is defined'); }

# Create a temporary directory for testing
my $temp_dir = tempdir(CLEANUP => 1);

# Test case: Successful iteration through directory contents
my $dir = Path::Class::Dir->new($temp_dir);
my $result = eval { $dir->next() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result'); }

# Test case: Directory cannot be opened
my $mock = mock 'Path::Class::Dir' => (
    open => sub { return undef },
);
my $result2 = eval { $mock->next() };
if ($@) { like($@, qr/Can't open directory/, 'Correct error message'); } else { fail('Expected function to crash'); }

# Test case: End of directory is reached
my $mock2 = mock 'Path::Class::Dir' => (
    open => sub { return bless {}, 'IO::Dir' },
    '{dh}' => bless {}, 'IO::Dir',
);
my $result3 = eval { $mock2->{dh}->read = sub { return undef }; $mock2->next() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result3, 'Function returns undef at end of directory'); }

# Test case: Entry in directory is a file
my $file = tempfile(DIR => $temp_dir);
my $result4 = eval { $dir->next() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result4, 'Function returns file object'); }

# Test case: Entry in directory is a directory
my $subdir = tempdir(DIR => $temp_dir);
my $result5 = eval { $dir->next() };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result5, 'Function returns directory object'); }

done_testing();
