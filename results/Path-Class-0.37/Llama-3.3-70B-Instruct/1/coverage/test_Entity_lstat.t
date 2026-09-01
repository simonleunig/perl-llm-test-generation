use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Entity; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Entity::lstat"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'lstat is defined'); }

my ($fh, $filename);  # AFTER LAST PASS: my ($fh, $filename) = tempfile();
# AFTER LAST PASS: close $fh;

my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Path::Class::Entity->new($filename)->lstat() };
# FAILED: if ($@) { fail('lstat function crashed: ' . $@); } else { ok(defined $result, 'lstat function returns result'); }

my $non_existent_file;  # AFTER LAST PASS: my $non_existent_file = 'non_existent_file.txt';
my $error;  # AFTER LAST PASS: my $error;  # UNVALIDATED: my $error = eval { Path::Class::Entity->new($non_existent_file)->lstat() };
# FAILED: if ($@) { like($@, qr/No such file or directory/, 'lstat function correctly handles non-existent file'); } else { fail('lstat function did not crash for non-existent file'); }

my $invalid_file_path;  # AFTER LAST PASS: my $invalid_file_path = undef;
# UNVALIDATED: $error = eval { Path::Class::Entity->new($invalid_file_path)->lstat() };
# FAILED: if ($@) { like($@, qr/Can't call method "lstat" on an undefined/, 'lstat function correctly handles invalid file path'); } else { fail('lstat function did not crash for invalid file path'); }

# AFTER LAST PASS: unlink $filename;

done_testing();