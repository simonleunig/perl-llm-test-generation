use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::open"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'open is defined'); }

# Create a temporary directory
my $temp_dir = tempdir(CLEANUP => 1);
my $dir = Path::Class::Dir->new($temp_dir);

# Test case: Open a directory
my $result = eval { $dir->open() };
if ($@) { fail('Open crashed: ' . $@); } else { ok(defined $result, 'Open returns result'); }

# Test case: Check if the returned object is an IO::Dir
my $is_io_dir = eval { $result->isa('IO::Dir') };
if ($@) { fail('isa check crashed: ' . $@); } else { ok($is_io_dir, 'Returned object is an IO::Dir'); }

# Test case: Try to open a non-existent directory
my $non_existent_dir = Path::Class::Dir->new('/non/existent/directory');
my $non_existent_result = eval { $non_existent_dir->open() };
if ($@) { like($@, qr/No such file or directory/, 'Open fails for non-existent directory'); } else { fail('Open did not fail for non-existent directory'); }

done_testing();
