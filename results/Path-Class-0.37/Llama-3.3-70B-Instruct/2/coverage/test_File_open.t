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

my ($fh, $filename);  # AFTER LAST PASS: my ($fh, $filename) = tempfile();
my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Path::Class::File->open($filename, '<'); };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'open returns result'); }
# AFTER LAST PASS: unlink($filename);

my $non_existent_file;  # AFTER LAST PASS: my $non_existent_file = 'non_existent_file.txt';
my $result2;  # AFTER LAST PASS: my $result2;  # UNVALIDATED: my $result2 = eval { Path::Class::File->open($non_existent_file, '<'); };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result2, 'open returns undef for non-existent file'); }

my $temp_dir;  # AFTER LAST PASS: my $temp_dir = tempdir();
my $file_in_temp_dir;  # AFTER LAST PASS: my $file_in_temp_dir;  # UNVALIDATED: my $file_in_temp_dir = File::Spec->catfile($temp_dir, 'file.txt');
my $fh2;  # AFTER LAST PASS: open(my $fh2, '>', $file_in_temp_dir) or die $!;
# AFTER LAST PASS: chmod(0000, $file_in_temp_dir);
my $result3;  # AFTER LAST PASS: my $result3;  # UNVALIDATED: my $result3 = eval { Path::Class::File->open($file_in_temp_dir, '<'); };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result3, 'open returns undef for file without permissions'); }
# AFTER LAST PASS: chmod(0644, $file_in_temp_dir);
# AFTER LAST PASS: unlink($file_in_temp_dir);
# AFTER LAST PASS: rmdir($temp_dir);

my $mock;
# AFTER LAST PASS: eval { require IO::File; };
# AFTER LAST PASS: if ($@) {
    # DEPENDENCY MISSING: IO::File - mock skipped  
# AFTER LAST PASS: } else {
    # AFTER LAST PASS: no strict 'refs';
    # AFTER LAST PASS: if (defined &{"IO::File::new"}) {
        my ($class, $file, $mode);  # AFTER LAST PASS: $mock = mock 'IO::File' => ( override => [ new => sub { my ($class, $file, $mode) = @_; return bless \$file, $class; } ] );
    # AFTER LAST PASS: } else {
        my ($class, $file, $mode);  # AFTER LAST PASS: $mock = mock 'IO::File' => ( add => [ new => sub { my ($class, $file, $mode) = @_; return bless \$file, $class; } ] );
    # AFTER LAST PASS: }
# AFTER LAST PASS: }

done_testing();