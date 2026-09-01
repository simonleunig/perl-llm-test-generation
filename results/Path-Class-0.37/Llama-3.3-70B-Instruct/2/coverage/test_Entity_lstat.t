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

my ($fh, $filename);  # AFTER LAST PASS: my ($fh, $filename) = tempfile();
my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Path::Class::Entity->lstat($filename) };
# FAILED: if ($@) { fail('Function crashed on existing file: ' . $@); } else { ok(defined $result, 'Function returns result for existing file'); }
# AFTER LAST PASS: unlink($filename);

my $dir;  # AFTER LAST PASS: my $dir = tempdir();
# UNVALIDATED: $result = eval { Path::Class::Entity->lstat($dir) };
# FAILED: if ($@) { fail('Function crashed on existing directory: ' . $@); } else { ok(defined $result, 'Function returns result for existing directory'); }
# AFTER LAST PASS: File::Temp::rmdir($dir);

# UNVALIDATED: $result = eval { Path::Class::Entity->lstat('non_existent_file') };
# FAILED: if ($@) { fail('Function crashed on non-existent file: ' . $@); } else { ok(!defined $result, 'Function returns undef for non-existent file'); }

my ($fh2, $filename2);  # AFTER LAST PASS: my ($fh2, $filename2) = tempfile();
# AFTER LAST PASS: chmod 0000, $filename2;
# UNVALIDATED: $result = eval { Path::Class::Entity->lstat($filename2) };
# FAILED: if ($@) { fail('Function crashed on inaccessible file: ' . $@); } else { ok(!defined $result, 'Function returns undef for inaccessible file'); }
# AFTER LAST PASS: chmod 0600, $filename2;
# AFTER LAST PASS: unlink($filename2);

done_testing();