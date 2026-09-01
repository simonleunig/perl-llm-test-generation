use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

# Function existence check
my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::copy_to"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'copy_to is defined'); }

# Test case 1: Copy to a file
my ($fh, $filename) = tempfile();
my $file = Path::Class::File->new($filename);
my $dest = Path::Class::File->new($filename . '.copy');
my $result = eval { $file->copy_to($dest) };
if ($@) { fail('Copy to file crashed: ' . $@); } else { ok(defined $result, 'Copy to file returns result'); }
ok(-f $dest->stringify, 'Destination file exists');

# Test case 2: Copy to a directory
my $dir = tempdir();
my $dest_dir = Path::Class::Dir->new($dir);
my $result2 = eval { $file->copy_to($dest_dir) };
if ($@) { fail('Copy to directory crashed: ' . $@); } else { ok(defined $result2, 'Copy to directory returns result'); }
ok(-f File::Spec->catfile($dir, $file->basename), 'Destination file exists in directory');

# Test case 3: Copy to an object of unknown type
my $unknown_dest = bless {}, 'UnknownType';
my $result3 = eval { $file->copy_to($unknown_dest) };
if ($@) { like($@, qr/Don't know how to copy files to objects of type 'UnknownType'/, 'Copy to unknown type raises error'); } else { fail('Copy to unknown type did not raise error'); }

# Test case 4: Copy to a non-existent directory
my $non_existent_dir = Path::Class::Dir->new('non_existent_dir');
my $result4 = eval { $file->copy_to($non_existent_dir) };
if ($@) { like($@, qr/Can't copy to directory non_existent_dir: no such directory/, 'Copy to non-existent directory raises error'); } else { fail('Copy to non-existent directory did not raise error'); }

# Test case 5: Copy to a file that is a directory
my $file_that_is_dir = Path::Class::File->new($dir);
my $result5 = eval { $file->copy_to($file_that_is_dir) };
if ($@) { like($@, qr/Can't copy to file/, 'Copy to file that is a directory raises error'); } else { fail('Copy to file that is a directory did not raise error'); }

# Test case 6: Copy to a directory that is a file
my $dir_that_is_file = Path::Class::Dir->new($filename);
my $result6 = eval { $file->copy_to($dir_that_is_file) };
if ($@) { like($@, qr/Can't copy to directory/, 'Copy to directory that is a file raises error'); } else { fail('Copy to directory that is a file did not raise error'); }

done_testing();
