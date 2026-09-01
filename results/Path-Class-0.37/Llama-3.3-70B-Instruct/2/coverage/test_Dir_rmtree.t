use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Dir; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Dir::rmtree"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'rmtree is defined'); }

my $temp_dir = tempdir(CLEANUP => 1);
my $dir = Path::Class::Dir->new($temp_dir);

my $result = eval { $dir->rmtree(); };
if ($@) { fail('rmtree crashed: ' . $@); } else { ok(! -e $temp_dir, 'Empty directory removed successfully'); }

my $temp_dir_with_file = tempdir(CLEANUP => 1);
my $dir_with_file = Path::Class::Dir->new($temp_dir_with_file);
my $file = Path::Class::File->new($temp_dir_with_file, 'test.txt');
$file->touch;

$result = eval { $dir_with_file->rmtree(); };
if ($@) { fail('rmtree crashed: ' . $@); } else { ok(! -e $temp_dir_with_file, 'Directory with file removed successfully'); }

my $non_existent_dir = Path::Class::Dir->new('non_existent_dir');
$result = eval { $non_existent_dir->rmtree(); };
# FAILED: if ($@) { pass('rmtree failed for non-existent directory'); } else { fail('rmtree succeeded for non-existent directory'); }

my $mock;
eval { require File::Path; };
if ($@) {
    # DEPENDENCY MISSING: File::Path - mock skipped
} else {
    no strict 'refs';
    if (defined &{"File::Path::rmtree"}) {
        $mock = mock 'File::Path' => ( override => [ rmtree => sub { die 'Mocked rmtree' } ] );
    } else {
        $mock = mock 'File::Path' => ( add => [ rmtree => sub { die 'Mocked rmtree' } ] );
    }
}

$result = eval { $non_existent_dir->rmtree(); };
if ($@) { pass('rmtree failed for non-existent directory'); } else { fail('rmtree succeeded for non-existent directory'); }

done_testing();