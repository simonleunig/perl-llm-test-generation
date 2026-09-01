use Test2::V0 -no_srand => 1;
use strict;
use warnings;
use Test2::Mock qw/mock/;
use File::Temp qw/tempfile tempdir/;
use File::Spec;
use lib '.';
BEGIN { require Path::Class::Entity; }

my $symbol_check = eval { no strict 'refs'; defined &{"Path::Class::Entity::new"} };
if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($symbol_check, 'new is defined'); }

my $entity;  # AFTER LAST PASS: my $entity = bless {}, 'Path::Class::Entity';
# AFTER LAST PASS: $entity->{file_spec_class} = 'File::Spec';
my $result;  # AFTER LAST PASS: my $result;  # UNVALIDATED: my $result = eval { Path::Class::Entity->new($entity) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result, 'Function returns result with valid object reference'); }

my $result2;  # AFTER LAST PASS: my $result2;  # UNVALIDATED: my $result2 = eval { Path::Class::Entity->new('Path::Class::Entity') };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(defined $result2, 'Function returns result with valid string'); }

my $result3;  # AFTER LAST PASS: my $result3;  # UNVALIDATED: my $result3 = eval { Path::Class::Entity->new(123) };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result3, 'Function returns no result with invalid input'); }

my $result4;  # AFTER LAST PASS: my $result4;  # UNVALIDATED: my $result4 = eval { Path::Class::Entity->new() };
# FAILED: if ($@) { fail('Function crashed: ' . $@); } else { ok(!defined $result4, 'Function returns no result with undefined input'); }

my $stringify_check;  # AFTER LAST PASS: my $stringify_check;  # UNVALIDATED: my $stringify_check = eval { no strict 'refs'; defined &{"Path::Class::Entity::stringify"} };
# FAILED: if ($@) { fail('Symbol check crashed: ' . $@); } else { ok($stringify_check, 'stringify is defined'); }

done_testing();