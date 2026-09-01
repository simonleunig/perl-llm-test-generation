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

my $temp_dir = tempdir(CLEANUP => 1);
my $temp_file = File::Spec->catfile($temp_dir, 'test_file.txt');
open(my $fh, '>', $temp_file) or fail('Failed to create temporary file: ' . $!);
close($fh);

my $entity = Path::Class::Entity->new($temp_file);
my $result = eval { $entity->resolve() };
if ($@) { fail('Resolve crashed: ' . $@); } else { ok(defined $result, 'Resolve returns result for absolute path'); }

my $relative_entity = Path::Class::Entity->new('test_file.txt');
my $relative_result = eval { $relative_entity->resolve() };
if ($@) { fail('Resolve crashed: ' . $@); } else { ok(defined $relative_result, 'Resolve returns result for relative path'); }

my $non_existent_entity = Path::Class::Entity->new('non_existent_file.txt');
my $non_existent_result = eval { $non_existent_entity->resolve() };
if ($@) { like($@, qr/No such file or directory/, 'Resolve throws error for non-existent path'); } else { fail('Resolve did not throw error for non-existent path'); }

done_testing();