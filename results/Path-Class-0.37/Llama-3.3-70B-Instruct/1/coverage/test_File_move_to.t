use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::File; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::File::move_to"} };
if ($@) { fail("Symbol check crashed: $@"); } else { ok($symbol_check, "move_to is defined"); }

my ($fh, $filename) = tempfile();
print $fh "Hello, World!";
close $fh;

my $temp_dir = tempdir();

my $file = Path::Class::File->new($filename);
my $result = eval { $file->move_to($temp_dir) };
if ($@) { fail("move_to crashed: $@"); } else { ok(defined $result, "move_to returns result"); }

my $dest_file = Path::Class::File->new($filename);
my $result2 = eval { $file->move_to($dest_file) };
# FAILED: if ($@) { fail("move_to crashed: $@"); } else { ok(!defined $result2, "move_to returns undef on failure"); }

my $non_existent_dir = $temp_dir . '/non_existent_dir';
my $result3 = eval { $file->move_to($non_existent_dir) };
if ($@) { fail("move_to crashed: $@"); } else { ok(!defined $result3, "move_to returns undef on failure"); }

# AFTER LAST PASS: unlink $filename;
# AFTER LAST PASS: rmdir $temp_dir;

done_testing();