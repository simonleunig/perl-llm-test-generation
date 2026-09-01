use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::move_to"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'move_to is defined'); }

# Test case 1: Successful move operation
my ($fh, $filename) = tempfile();
my $dir = tempdir();
my $file = Path::Class::File->new($filename);
my $dest = Path::Class::File->new("$dir/test.txt");
my $result = eval { $file->move_to($dest) };
if ($@) { fail('move_to crashed: ' . $@); } else { ok(defined $result, 'move_to returns result'); }

# Test case 2: Move operation failure
my ($fh2, $filename2) = tempfile();
my $file2 = Path::Class::File->new($filename2);
my $dest2 = Path::Class::File->new("/non/existent/path");
my $result2 = eval { $file2->move_to($dest2) };
if ($@) { fail('move_to crashed: ' . $@); } else { ok(!defined $result2, 'move_to returns undef on failure'); }

# Test case 3: Invalid input
my $result3 = eval { Path::Class::File->move_to() };
if ($@) { fail('move_to crashed: ' . $@); } else { ok(!defined $result3, 'move_to returns undef with invalid input'); }

done_testing();
