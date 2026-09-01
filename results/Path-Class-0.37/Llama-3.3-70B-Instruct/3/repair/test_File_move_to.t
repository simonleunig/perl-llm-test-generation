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
my $file = Path::Class::File->new($filename);
my $dest_dir = tempdir();
my $dest_file = File::Spec->catfile($dest_dir, 'moved_file');
my $result = eval { $file->move_to($dest_file) };
if ($@) { fail('move_to crashed: ' . $@); } else { ok(defined $result, 'move_to returns result'); }
ok(-f $dest_file, 'File moved successfully');

# Test case 2: Move operation fails due to permission issues
my ($fh2, $filename2) = tempfile();
my $file2 = Path::Class::File->new($filename2);
my $dest_dir2 = '/root';  # Non-writable directory
my $dest_file2 = File::Spec->catfile($dest_dir2, 'moved_file');
my $result2 = eval { $file2->move_to($dest_file2) };
if ($@) { fail('move_to crashed: ' . $@); } else { ok(!defined $result2, 'move_to returns undef on failure'); }
ok(!-f $dest_file2, 'File not moved due to permission issues');

# Test case 3: Move operation fails due to non-existent destination directory
my ($fh3, $filename3) = tempfile();
my $file3 = Path::Class::File->new($filename3);
my $dest_dir3 = '/non/existent/dir';  # Non-existent directory
my $dest_file3 = File::Spec->catfile($dest_dir3, 'moved_file');
my $result3 = eval { $file3->move_to($dest_file3) };
if ($@) { fail('move_to crashed: ' . $@); } else { ok(!defined $result3, 'move_to returns undef on failure'); }
ok(!-f $dest_file3, 'File not moved due to non-existent destination directory');

done_testing();
