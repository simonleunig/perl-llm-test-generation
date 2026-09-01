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

# Create a temporary directory
my $temp_dir = tempdir();
my $dir = Path::Class::Dir->new($temp_dir);

# Test case: Directory can be opened and iterated through
my $result = eval { $dir->next() };
if ($@) { fail('next crashed: ' . $@); } else { ok(defined $result, 'next returns result'); }

# Test case: Directory cannot be opened
my $mock_dir = mock 'Path::Class::Dir' => (
    open => sub { return undef },
);
$result = eval { $mock_dir->next() };
if ($@) { like($@, qr/Can't open directory/, 'next throws exception when directory cannot be opened'); } else { fail('next did not throw exception'); }

# Test case: End of directory is reached
my $mock_dh = mock 'IO::Dir' => (
    read => sub { return undef },
);
my $mock_dir_with_dh = mock 'Path::Class::Dir' => (
    open => sub { return $mock_dh },
);
$result = eval { $mock_dir_with_dh->next() };
if ($@) { fail('next crashed: ' . $@); } else { ok(!defined $result, 'next returns undef when end of directory is reached'); }

# Test case: Entry in directory is a file
my $mock_file = mock 'Path::Class::File' => (
    new => sub { return bless {}, 'Path::Class::File' },
);
my $mock_dir_with_file = mock 'Path::Class::Dir' => (
    open => sub { return $mock_dh },
    file => sub { return $mock_file },
);
$result = eval { $mock_dir_with_file->next() };
if ($@) { fail('next crashed: ' . $@); } else { ok(defined $result && ref($result) eq 'Path::Class::File', 'next returns file object when entry is a file'); }

# Test case: Entry in directory is a directory
my $mock_subdir = mock 'Path::Class::Dir' => (
    new => sub { return bless {}, 'Path::Class::Dir' },
);
my $mock_dir_with_subdir = mock 'Path::Class::Dir' => (
    open => sub { return $mock_dh },
    subdir => sub { return $mock_subdir },
);
$result = eval { $mock_dir_with_subdir->next() };
if ($@) { fail('next crashed: ' . $@); } else { ok(defined $result && ref($result) eq 'Path::Class::Dir', 'next returns dir object when entry is a directory'); }

done_testing();
