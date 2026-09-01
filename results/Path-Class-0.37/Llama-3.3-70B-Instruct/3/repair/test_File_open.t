use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::open"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'open is defined'); }

my ($fh, $filename) = tempfile();
my $file = Path::Class::File->new($filename);
my $result = eval { $file->open('r') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'open returns result for existing file'); }
unlink $filename;

my $non_existent_file = Path::Class::File->new('non_existent_file.txt');
$result = eval { $non_existent_file->open('r') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result, 'open returns undef for non-existent file'); }

my $temp_dir = tempdir();
my $dir = Path::Class::File->new($temp_dir);
$result = eval { $dir->open('r') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result, 'open returns undef for directory'); }
require File::Path;
File::Path::rmdir($temp_dir);

my ($fh2, $filename2) = tempfile();
my $file2 = Path::Class::File->new($filename2);
$result = eval { $file2->open('invalid_mode') };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result, 'open returns undef for invalid mode'); }
unlink $filename2;

done_testing();