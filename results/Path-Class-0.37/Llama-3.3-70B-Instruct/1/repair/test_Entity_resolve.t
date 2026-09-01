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

my ($fh, $filename) = tempfile();
my $entity = Path::Class::Entity->new($filename);
my $result = eval { $entity->resolve() };
if ($@) { fail('Resolve existing file crashed: ' . $@); } else { ok(defined $result, 'Resolve existing file returns result'); }
unlink($filename);

my $non_existent_file = 'non_existent_file.txt';
my $entity_non_existent = Path::Class::Entity->new($non_existent_file);
my $result_non_existent = eval { $entity_non_existent->resolve() };
if ($@) { like($@, qr/No such file or directory/, 'Resolve non-existing file throws correct error'); } else { fail('Resolve non-existing file did not throw error'); }

my $relative_path = './relative_path';
mkdir($relative_path);
my $entity_relative = Path::Class::Entity->new($relative_path);
my $result_relative = eval { $entity_relative->resolve() };
if ($@) { fail('Resolve relative path crashed: ' . $@); } else { ok(defined $result_relative, 'Resolve relative path returns result'); }
rmdir($relative_path);

my $absolute_path = File::Spec->rel2abs($relative_path);
my $entity_absolute = Path::Class::Entity->new($absolute_path);
my $result_absolute = eval { $entity_absolute->resolve() };
if ($@) { fail('Resolve absolute path crashed: ' . $@); } else { ok(defined $result_absolute, 'Resolve absolute path returns result'); }

done_testing();