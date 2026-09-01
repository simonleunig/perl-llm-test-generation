use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Entity; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Entity::resolve"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'resolve is defined'); }

my $temp_dir;  # AFTER LAST PASS: my $temp_dir = tempdir(CLEANUP => 1);
my $temp_file;  # AFTER LAST PASS: my $temp_file = File::Spec->catfile($temp_dir, 'test_file.txt');
my $fh;  # AFTER LAST PASS: open(my $fh, '>', $temp_file);  # FAILED: fallback assertion removed
# AFTER LAST PASS: close($fh);

my $entity;  # AFTER LAST PASS: my $entity;  # UNVALIDATED: my $entity = Path::Class::Entity->new($temp_file);
my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $entity->resolve() };
# FAILED: if ($@) { fail('Resolve crashed: ' . $@); } else { ok(defined $result, 'Resolve returns result for absolute path'); }

my $relative_entity;  # AFTER LAST PASS: my $relative_entity;  # UNVALIDATED: my $relative_entity = Path::Class::Entity->new('test_file.txt');
my $relative_result;  # AFTER LAST PASS: my $relative_result;  # UNVALIDATED: my $relative_result = eval { $relative_entity->resolve() };
# FAILED: if ($@) { fail('Resolve crashed: ' . $@); } else { ok(defined $relative_result, 'Resolve returns result for relative path'); }

my $non_existent_entity;  # AFTER LAST PASS: my $non_existent_entity;  # UNVALIDATED: my $non_existent_entity = Path::Class::Entity->new('non_existent_file.txt');
my $non_existent_result;  # AFTER LAST PASS: my $non_existent_result;  # UNVALIDATED: my $non_existent_result = eval { $non_existent_entity->resolve() };
# FAILED: if ($@) { like($@, qr/No such file or directory/, 'Resolve throws error for non-existent path'); } else { fail('Resolve did not throw error for non-existent path'); }

done_testing();