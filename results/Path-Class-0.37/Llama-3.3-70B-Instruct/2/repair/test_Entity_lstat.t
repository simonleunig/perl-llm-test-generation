use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw(tempfile tempdir);
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Entity; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Entity::lstat"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'lstat is defined'); }

my ($fh, $filename) = tempfile();
my $result = eval { Path::Class::Entity->lstat($filename) };
if ($@) { fail('Function crashed on existing file: ' . $@); } else { ok(defined $result, 'Function returns result for existing file'); }
unlink($filename);

my $dir = tempdir();
$result = eval { Path::Class::Entity->lstat($dir) };
if ($@) { fail('Function crashed on existing directory: ' . $@); } else { ok(defined $result, 'Function returns result for existing directory'); }
File::Temp::rmdir($dir);

$result = eval { Path::Class::Entity->lstat('non_existent_file') };
if ($@) { fail('Function crashed on non-existent file: ' . $@); } else { ok(!defined $result, 'Function returns undef for non-existent file'); }

my ($fh2, $filename2) = tempfile();
chmod 0000, $filename2;
$result = eval { Path::Class::Entity->lstat($filename2) };
if ($@) { fail('Function crashed on inaccessible file: ' . $@); } else { ok(!defined $result, 'Function returns undef for inaccessible file'); }
chmod 0600, $filename2;
unlink($filename2);

done_testing();