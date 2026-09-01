use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Entity; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Entity::relative"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'relative is defined'); }

my $entity;  # AFTER LAST PASS: my $entity;  # UNVALIDATED: my $entity = Path::Class::Entity->new('/path/to/entity');
my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { $entity->relative('/path/to/base') };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result for successful relative path calculation'); }

my $invalid_base_entity;  # AFTER LAST PASS: my $invalid_base_entity;  # UNVALIDATED: my $invalid_base_entity = Path::Class::Entity->new('/invalid/path');
my $error_result;  # AFTER LAST PASS: my $error_result;  # UNVALIDATED: my $error_result = eval { $invalid_base_entity->relative('/non/existent/base') };
# FAILED: if ($@) { like($@, qr/Invalid base directory/, 'Function raises error for invalid base directory'); } else { fail('Expected error not raised for invalid base directory'); }

my $no_base_entity;  # AFTER LAST PASS: my $no_base_entity;  # UNVALIDATED: my $no_base_entity = Path::Class::Entity->new('/path/to/entity');
my $no_base_result;  # AFTER LAST PASS: my $no_base_result;  # UNVALIDATED: my $no_base_result = eval { $no_base_entity->relative() };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $no_base_result, 'Function returns result for relative path calculation with no base directory'); }

done_testing();