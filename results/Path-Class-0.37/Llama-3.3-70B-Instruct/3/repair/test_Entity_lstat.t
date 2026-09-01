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

my $temp_file = tempfile();
my $result = eval { Path::Class::Entity->lstat($temp_file) };
if ($@) { fail('lstat crashed: ' . $@); } else { ok(defined $result, 'lstat returns result'); }

my $non_existent_file = 'non_existent_file.txt';
my $non_existent_result = eval { Path::Class::Entity->lstat($non_existent_file) };
if ($@) { ok(!defined $non_existent_result, 'lstat returns undef for non-existent file'); } else { fail('lstat did not return undef for non-existent file'); }

my $invalid_input = 123;
my $invalid_result = eval { Path::Class::Entity->lstat($invalid_input) };
if ($@) { ok(1, 'lstat crashes with invalid input'); } else { fail('lstat did not crash with invalid input'); }

done_testing();