use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::copy_to"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'copy_to is defined'); }

my ($fh, $filename) = tempfile();
my $file = Path::Class::File->new($filename);
my $dest = Path::Class::File->new($filename . '.copy');
my $result = eval { $file->copy_to($dest) };
if ($@) { fail('Copy to file crashed: ' . $@); } else { ok(defined $result, 'Copy to file returns result'); }
ok(-f $dest->stringify, 'Destination file exists');

my $dir = tempdir();
my $dest_dir = Path::Class::Dir->new($dir);
my $result2 = eval { $file->copy_to($dest_dir) };
if ($@) { fail('Copy to directory crashed: ' . $@); } else { ok(defined $result2, 'Copy to directory returns result'); }
ok(-f File::Spec->catfile($dir, $file->basename), 'Destination file exists in directory');

my $unknown_dest = bless {}, 'UnknownType';
my $result3 = eval { $file->copy_to($unknown_dest) };
if ($@) { like($@, qr/Don't know how to copy files to objects of type 'UnknownType'/, 'Copy to unknown type raises error'); } else { fail('Copy to unknown type did not raise error'); }

my $non_existent_dir = Path::Class::Dir->new('non_existent_dir');
my $result4 = eval { $file->copy_to($non_existent_dir) };
if ($@) { like($@, qr/Can't copy to directory non_existent_dir: no such directory/, 'Copy to non-existent directory raises error'); } else { fail('Copy to non-existent directory did not raise error'); }

my $dir_file = Path::Class::File->new($dir);
my $result5 = eval { $file->copy_to($dir_file) };
if ($@) { like($@, qr/Can't copy to file/, 'Copy to file that is a directory raises error'); } else { fail('Copy to file that is a directory did not raise error'); }

done_testing();