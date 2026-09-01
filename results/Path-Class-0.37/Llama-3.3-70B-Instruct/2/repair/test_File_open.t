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
my $result = eval { Path::Class::File->open($filename, '<'); };
if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'open returns result'); }
unlink($filename);

my $non_existent_file = 'non_existent_file.txt';
my $result2 = eval { Path::Class::File->open($non_existent_file, '<'); };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result2, 'open returns undef for non-existent file'); }

my $temp_dir = tempdir();
my $file_in_temp_dir = File::Spec->catfile($temp_dir, 'file.txt');
open(my $fh2, '>', $file_in_temp_dir) or die $!;
chmod(0000, $file_in_temp_dir);
my $result3 = eval { Path::Class::File->open($file_in_temp_dir, '<'); };
if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result3, 'open returns undef for file without permissions'); }
chmod(0644, $file_in_temp_dir);
unlink($file_in_temp_dir);
rmdir($temp_dir);

my $mock;
eval { require IO::File; };
if ($@) {
    # DEPENDENCY MISSING: IO::File - mock skipped  
} else {
    no strict 'refs';
    if (defined &{"IO::File::new"}) {
        $mock = mock 'IO::File' => ( override => [ new => sub { my ($class, $file, $mode) = @_; return bless \$file, $class; } ] );
    } else {
        $mock = mock 'IO::File' => ( add => [ new => sub { my ($class, $file, $mode) = @_; return bless \$file, $class; } ] );
    }
}

done_testing();